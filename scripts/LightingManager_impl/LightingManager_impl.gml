enum LIGHTING_SURFACE {
	FINAL = 0,
	SINGLE = 1,
	FOUR = 2,
	BLUR = 3,
	COUNT = 4,
}

enum LIGHT {
	GLOBAL = 0,
	
}

enum CASTER {
	STATIC = 0,
	DYNAMIC = 1,
}

function LightingManager() constructor{
	lights = ds_list_create();
	static_casters = ds_list_create();
	dynamic_casters = ds_list_create();
	
	lighting_surfaces = array_create(LIGHTING_SURFACE.COUNT, -1);
	
	dirty_casters = false;
	dirty_surfaces = false;
	
	buffer = -1;
	buffer_vertices = 0;
	
	surface_width = 640;
	surface_height = 360;
	
	static SetResolution = function(width_, height_) {
		surface_width = width_;
		surface_height = height_;
		
		dirty_surfaces = true;
	}
	
	static RegisterLight = function(instance_) {
		ds_list_add(lights, instance_);
	}	
	
	static UnregisterLight = function(instance_) {
		ds_list_delete(lights, ds_list_find_index(lights, instance_));
	}
	
	static RegisterCaster = function(instance_, type_) {
		switch(type_) {
			case CASTER.STATIC: {
				ds_list_add(static_casters, instance_);
			}
			case CASTER.DYNAMIC: {
				ds_list_add(dynamic_casters, instance_);
			}
		}
		dirty_casters = true;
	}
	
	static UnregisterCaster = function(instance_, type_) {
		switch(type) {
			case CASTER.STATIC: {
				ds_list_delete(static_casters, ds_list_find_index(static_casters, instance_));
			}
			case CASTER.DYNAMIC: {
				ds_list_delete(dynamic_casters, ds_list_find_index(dynamic_casters, instance_));
			}
		}
		dirty_casters = true;
	}
	
	static Render = function() {
		// Check if new casters were added or removed
		if (dirty_casters) {
			RebuildBuffer();
			dirty_casters = false;
		}
		
		// Check if resolution changed
		if (dirty_surfaces) {
			for(var i = 0; i < LIGHTING_SURFACE.COUNT; i++) {
				if (surface_exists(lighting_surfaces[i])) {
					surface_free(lighting_surfaces[i]);
				}
			}
			dirty_surfaces = false;
		}
		
		// Check for surfaces
		for(var i = 0; i < LIGHTING_SURFACE.COUNT; i++) {
			surface_depth_disable(false);
			
			if (!surface_exists(lighting_surfaces[i])) {
				lighting_surfaces[i] = surface_create(surface_width, surface_height);
			}
			surface_depth_disable(true);
		}
		
		// Clean final surface to 0
		surface_set_target(lighting_surfaces[LIGHTING_SURFACE.FINAL]);
		gpu_set_blendmode_ext(bm_one, bm_zero);
		draw_clear_alpha(c_black, 0.0);
		surface_reset_target();
		
		var lights_count = ds_list_size(lights);
		var light_positions = array_create(8, 0);
		
		var lights_start = 0;
		var lights_end = 0;
		
		var light_shadows_mat = matrix_build(-camera_get_view_x(view_camera[0]) * (surface_width / view_wport[0]), -camera_get_view_y(view_camera[0]) * (surface_height / view_hport[0]), 0, 0, 0, 0, surface_width / view_wport[0], surface_height / view_hport[0], 1);
					
		// Go through all lights in groups
		while(lights_start < lights_count) {
			lights_end = min(lights_count, lights_start + 4);
			
			// Clear group surface to 0
			surface_set_target(lighting_surfaces[LIGHTING_SURFACE.FOUR]);
			gpu_set_blendenable(false);
			draw_clear_alpha(c_black, 0.0);
			gpu_set_blendenable(true);
			
			matrix_set(matrix_world, light_shadows_mat);
			
			// Draw group lights to separate channels
			shader_set(light_channel_shd);
			gpu_set_blendmode_ext(bm_one, bm_one);
			var uniform = shader_get_uniform(light_channel_shd, "u_fChannel");
			for(var i = lights_start; i < lights_end; i++) {
				var channel = i - lights_start;
				shader_set_uniform_f(uniform, channel);
				with(lights[| i]) {
					draw_self();
				}
				light_positions[channel * 2] = lights[| i].x; 
				light_positions[channel * 2 + 1] = lights[| i].y;
			}
			shader_reset();
			
			// Draw group shadows to separate channels
			shader_set(shadow_channel_shd);
			shader_set_uniform_f_array(shader_get_uniform(shadow_channel_shd, "u_vLightPos"), light_positions);
			gpu_set_blendmode_ext(bm_zero, bm_src_color);
			vertex_submit(buffer, pr_trianglelist, -1);
			shader_reset();
			surface_reset_target();
			
			matrix_set(matrix_world, matrix_build_identity());
			
			// Accumulare group lights and shadows to final surface
			surface_set_target(lighting_surfaces[LIGHTING_SURFACE.FINAL]);
			shader_set(shadow_merge_shd);
			gpu_set_blendmode_ext(bm_one, bm_one);
			draw_surface(lighting_surfaces[LIGHTING_SURFACE.FOUR], 0, 0);
			shader_reset();
			surface_reset_target();
			
			lights_start += 4;
		}
		
		// Blend final surface with world
		gpu_set_blendmode_ext(bm_dest_color, bm_src_color);
		draw_surface_stretched(lighting_surfaces[LIGHTING_SURFACE.FINAL], camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]), view_wport[0], view_hport[0]);

		gpu_set_blendmode_ext(bm_src_alpha, bm_inv_src_alpha);
	}
	
	static RebuildBuffer = function() {
		var static_casters_count = ds_list_size(static_casters);
		
		buffer = vertex_create_buffer();
		vertex_begin(buffer, global.shadow_vertex_format);
		
		for(var i = 0; i < static_casters_count; i++) {
			with(static_casters[| i]) {
				
				var buff = other.buffer;
				for(var ch = 0; ch < 4; ch++) {
					for(var j = 0; j < vertices_count; j++) {
						var vert1 = vertices[j];
						var vert2 = vertices[(j + 1) mod vertices_count];
						vertex_float4(buff, vert1.x, vert1.y, ch, 0);
						vertex_float4(buff, vert2.x, vert2.y, ch, 0);
						vertex_float4(buff, vert1.x, vert1.y, ch, 1);
		
						vertex_float4(buff, vert2.x, vert2.y, ch, 0);
						vertex_float4(buff, vert2.x, vert2.y, ch, 1);
						vertex_float4(buff, vert1.x, vert1.y, ch, 1);
					}
				}
				
			}
		}
		
		vertex_end(buffer);
		vertex_freeze(buffer);
		buffer_vertices = vertex_get_number(buffer);
	}
}
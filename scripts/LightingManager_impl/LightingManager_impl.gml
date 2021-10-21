enum LIGHTING_SURFACE {
	FINAL = 0,
	GROUP = 1,
	BLUR = 2,
	COUNT = 3,
}

// UNSUPORTED
//enum LIGHT {
//	GLOBAL_STATIC = 0,
//	STATIC = 1,
//	DYNAMIC = 2,
//	LIGHT_ONLY = 3,
//}

// TODO: CONVERT EVERYTHING TO PAIRS, OUTLINE IS JUST A WRAPPER FOR SPECIAL PAIRS
enum CASTER_FORMAT {
	OUTLINE = 0,
	PAIRS = 1,
}

enum CASTER {
	STATIC = 0,
	DYNAMIC = 1,
}

vertex_format_begin();
vertex_format_add_custom(vertex_type_float4, vertex_usage_position);
global.shadow_vertex_format = vertex_format_end();

function LightingManager() constructor{
	lights = ds_list_create();
	static_casters = ds_list_create();
	dynamic_casters = ds_list_create();
	
	lighting_surfaces = array_create(LIGHTING_SURFACE.COUNT, -1);
	
	dirty_casters = false;
	dirty_surfaces = false;
	blur_enabled = true;
	
	buffer = -1;
	buffer_vertices = 0;
	
	surface_width = 640;
	surface_height = 360;
	
	// CACHE
	light_positions = array_create(8, 0);
	light_screen_positions = array_create(8, 0);
	light_colors = array_create(16, 0);
	
	static SetResolution = function(width_, height_) {
		surface_width = width_;
		surface_height = height_;
		
		dirty_surfaces = true;
	}
	
	static SetBlur = function(enabled_) {
		blur_enabled = enabled_;
	}
	
	static ToggleBlur = function() {
		blur_enabled = !blur_enabled;
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
		CheckCasters();
		CheckSurfaces();
		
		// Clean final surface to 0
		surface_set_target(lighting_surfaces[LIGHTING_SURFACE.FINAL]);
		gpu_set_blendmode_ext(bm_one, bm_zero);
		draw_clear_alpha(c_black, 0.0);
		surface_reset_target();
		
		var lights_count = ds_list_size(lights);
		var lights_start = 0;
		var lights_end = 0;
		
		var light_shadows_mat = matrix_build(-camera_get_view_x(view_camera[0]) * (surface_width / view_wport[0]), -camera_get_view_y(view_camera[0]) * (surface_height / view_hport[0]), 0, 0, 0, 0, surface_width / view_wport[0], surface_height / view_hport[0], 1);
		
		// Go through all lights in groups
		while(lights_start < lights_count) {
			lights_end = min(lights_count, lights_start + 4);
			
			// Clear group surface to 0
			surface_set_target(lighting_surfaces[LIGHTING_SURFACE.GROUP]);
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
					draw_self()
				}
				
				var light = lights[| i];
				var color = light.image_blend;
				
				light_positions[channel * 2] = light.x; 
				light_positions[channel * 2 + 1] = light.y;
				light_screen_positions[channel * 2] = (light.x - camera_get_view_x(view_camera[0])) / view_wport[0]; 
				light_screen_positions[channel * 2 + 1] = (light.y - camera_get_view_y(view_camera[0])) / view_hport[0];
				light_colors[channel * 4] = color_get_red(color) / 255;
				light_colors[channel * 4 + 1] = color_get_green(color) / 255;
				light_colors[channel * 4 + 2] = color_get_blue(color) / 255;
				light_colors[channel * 4 + 3] = light.image_alpha;
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
			
			if (blur_enabled) {
				// Blur channels
				surface_set_target(lighting_surfaces[LIGHTING_SURFACE.BLUR]);
				shader_set(shadow_blur_shd);
				shader_set_uniform_f_array(shader_get_uniform(shadow_blur_shd, "u_vLightPos"), light_screen_positions);
				gpu_set_blendenable(false);
				draw_surface(lighting_surfaces[LIGHTING_SURFACE.GROUP], 0, 0);
				gpu_set_blendenable(true);
				shader_reset();
				surface_reset_target();			
			}
			var merge_surface = blur_enabled ? LIGHTING_SURFACE.BLUR : LIGHTING_SURFACE.GROUP;
			
			// Accumulare group lights and shadows to final surface
			surface_set_target(lighting_surfaces[LIGHTING_SURFACE.FINAL]);
			shader_set(shadow_merge_shd);
			shader_set_uniform_f_array(shader_get_uniform(shadow_merge_shd, "u_mColors"), light_colors);
			gpu_set_blendmode_ext(bm_one, bm_one);
			draw_surface(lighting_surfaces[merge_surface], 0, 0);
			shader_reset();
			surface_reset_target();
			
			lights_start += 4;
		}
		
		// Blend final surface with world
		gpu_set_blendmode_ext(bm_dest_color, bm_src_color);
		draw_surface_stretched(lighting_surfaces[LIGHTING_SURFACE.FINAL], camera_get_view_x(view_camera[0]), camera_get_view_y(view_camera[0]), view_wport[0], view_hport[0]);

		gpu_set_blendmode_ext(bm_src_alpha, bm_inv_src_alpha);
	}
	
	static CheckCasters = function() {
		if (dirty_casters) {
			RebuildBuffer();
			dirty_casters = false;
		}
	}
	
	
	static CheckSurfaces = function() {
		if (dirty_surfaces) {
			for(var i = 0; i < LIGHTING_SURFACE.COUNT; i++) {
				if (surface_exists(lighting_surfaces[i])) {
					surface_free(lighting_surfaces[i]);
				}
			}
			dirty_surfaces = false;
		}
		
		for(var i = 0; i < LIGHTING_SURFACE.COUNT; i++) {
			surface_depth_disable(false);
			
			if (!surface_exists(lighting_surfaces[i])) {
				lighting_surfaces[i] = surface_create(surface_width, surface_height);
			}
			surface_depth_disable(true);
		}
	}
	
	static RebuildBuffer = function() {
		var static_casters_count = ds_list_size(static_casters);
		
		buffer = vertex_create_buffer();
		vertex_begin(buffer, global.shadow_vertex_format);
		
		for(var i = 0; i < static_casters_count; i++) {
			with(static_casters[| i]) {
				
				var buff = other.buffer;
				
				for(var ch = 0; ch < 4; ch++) {
					for(var j = 0; j < vertices_count; j+=2) {
						var vert1 = vertices[j];
						var vert2 = vertices[j + 1];
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
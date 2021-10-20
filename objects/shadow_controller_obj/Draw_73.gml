if (global.use_new) 
	return;

profiler.Start();

// gpu_set_blendmode_ext(bm_array[src], bm_array[dest]);
for(var i = 0; i < LIGHTING_SURFACE.COUNT; i++) {
	if (!surface_exists(lighting_surfaces[i])) {
		lighting_surfaces[i] = surface_create(1280, 720);
	}
}

// Clear final lighting (sum of all lights and shadows)
surface_set_target(lighting_surfaces[LIGHTING_SURFACE.FINAL]);
draw_clear_alpha(c_black, 1.0);
surface_reset_target();

with(parent_light_obj) {
	// Single light and shadows
	surface_set_target(other.lighting_surfaces[LIGHTING_SURFACE.SINGLE]);
	gpu_set_blendmode_ext(bm_src_alpha, bm_inv_src_alpha);
	draw_clear_alpha(c_black, 1.0);
	draw_self();
	
	// Shadow
	shader_set(shadow_shd);
	shader_set_uniform_f(shader_get_uniform(shadow_shd, "u_vLightPos"), x, y);
	vertex_submit(other.static_shadow_buffer, pr_trianglelist, -1);
	shader_reset();
	surface_reset_target();

	// Blur
	//surface_set_target(other.lighting_surfaces[LIGHTING_SURFACE.BLUR]);
	//shader_set(shadow_blur_shd);
	//shader_set_uniform_f(shader_get_uniform(shadow_blur_shd, "u_vLightPos"), x, y);
	//draw_surface(other.lighting_surfaces[LIGHTING_SURFACE.SINGLE], 0, 0);
	//shader_reset();
	//surface_reset_target();
	
	// Accumulate
	surface_set_target(other.lighting_surfaces[LIGHTING_SURFACE.FINAL]);
	gpu_set_blendmode_ext(bm_one, bm_one);
	draw_surface(other.lighting_surfaces[LIGHTING_SURFACE.SINGLE], 0, 0);
	surface_reset_target();
}

// Ambient light
//surface_set_target(lighting_surfaces[LIGHTING_SURFACE.FINAL]);
//draw_set_alpha(0.1);
//gpu_set_blendmode_ext(bm_src_alpha, bm_inv_src_alpha);
//draw_rectangle_color(0, 0, 1280, 720, c_white, c_white, c_white, c_white, false);
//draw_set_alpha(1.0);
//surface_reset_target();

// Combine world and lighting
gpu_set_blendmode_ext(bm_dest_colour, bm_src_color);
draw_surface(lighting_surfaces[LIGHTING_SURFACE.FINAL], 0, 0);

gpu_set_blendmode_ext(bm_src_alpha, bm_inv_src_alpha);

var l = surface_getpixel(lighting_surfaces[LIGHTING_SURFACE.FINAL], 0, 0);

profiler.End();
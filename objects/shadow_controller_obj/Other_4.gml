show_debug_overlay(true);
game_set_speed(30, gamespeed_fps);

profiler = new Profiler();

lighting_surfaces = array_create(LIGHTING_SURFACE.COUNT, -1);
shadow_casters_count = instance_number(parent_shadow_obj);
lights_count = instance_number(parent_light_obj);
shadow_vertices = 0;

// Construct static shadow mesh, will not change for the duration of the game
static_shadow_buffer = vertex_create_buffer();
vertex_begin(static_shadow_buffer, global.shadow_vertex_format);
with(parent_shadow_obj) {
	var buffer = other.static_shadow_buffer;
	
	for(var i = 0; i < vertices_count; i++) {
		var vert1 = vertices[i];
		var vert2 = vertices[(i + 1) mod vertices_count];
		vertex_float3(buffer, round(vert1.x), round(vert1.y), 0.0);
		vertex_float4(buffer, 0, 0, 0, 0);
		vertex_float3(buffer, round(vert2.x), round(vert2.y), 0.0);
		vertex_float4(buffer, 0, 0, 0, 0);
		vertex_float3(buffer, round(vert1.x), round(vert1.y), 0.0);
		vertex_float4(buffer, 1, 0, 0, 0);
		
		vertex_float3(buffer, round(vert2.x), round(vert2.y), 0.0);
		vertex_float4(buffer, 0, 0, 0, 0);
		vertex_float3(buffer, round(vert2.x), round(vert2.y), 0.0);
		vertex_float4(buffer, 1, 0, 0, 0);
		vertex_float3(buffer, round(vert1.x), round(vert1.y), 0.0);
		vertex_float4(buffer, 1, 0, 0, 0);
	}
}

vertex_end(static_shadow_buffer);
vertex_freeze(static_shadow_buffer);

shadow_vertices = vertex_get_number(static_shadow_buffer);

bm_array[0] = bm_zero;
bm_array[1] = bm_one;
bm_array[2] = bm_src_colour;
bm_array[3] = bm_inv_src_colour;
bm_array[4] = bm_src_alpha;
bm_array[5] = bm_inv_src_alpha;
bm_array[6] = bm_dest_alpha;
bm_array[7] = bm_inv_dest_alpha;
bm_array[8] = bm_dest_colour;
bm_array[9] = bm_inv_dest_colour;
bm_array[10] = bm_src_alpha_sat

src = 0;
dest = 0;
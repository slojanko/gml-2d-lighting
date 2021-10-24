draw_set_color(c_red);
draw_text(0, 32, 0);
draw_text(0, 48, 0);

draw_text(0, 64, "Shadow casters " + string(ds_list_size(global.pLightingManager.casters[CASTER.STATIC])));
draw_text(0, 80, "Lights " + string(ds_list_size(global.pLightingManager.lights)));
draw_text(0, 96, "Shadow vertices " + string(global.pLightingManager.buffer_vertices[CASTER.STATIC]));
draw_text(0, 112, "Submitted shadow vertices " + string(global.pLightingManager.buffer_vertices[CASTER.STATIC] * ds_list_size(global.pLightingManager.lights)));
draw_text(0, 128, "Avg render time " + string(profiler.GetAverageTime(ProfilerFormat.ms)) + "ms");
draw_text(0, 144, "Fps " + string(fps));
draw_text(0, 160, "Application Surface " + string(surface_get_width(application_surface)) + "x" + string(surface_get_height(application_surface)));
draw_text(0, 176, "Lighting Surface " + string(surface_get_width(global.pLightingManager.lighting_surfaces[LIGHTING_SURFACE.FINAL])) + "x" + string(surface_get_height(global.pLightingManager.lighting_surfaces[LIGHTING_SURFACE.FINAL])));
draw_set_color(c_white);
draw_set_color(c_red);
draw_text(0, 32, 0);
draw_text(0, 48, 0);

draw_text(0, 64, "Shadow casters " + string(ds_list_size(global.pLightingManager.static_casters)));
draw_text(0, 80, "Lights " + string(ds_list_size(global.pLightingManager.lights)));
draw_text(0, 96, "Shadow vertices " + string(global.pLightingManager.buffer_vertices));
draw_text(0, 112, "Submitted shadow vertices " + string(global.pLightingManager.buffer_vertices * ds_list_size(global.pLightingManager.lights)));
draw_text(0, 128, "Avg render time " + string(profiler.GetAverageTime(ProfilerFormat.ms)) + "ms");
draw_text(0, 144, "Fps " + string(fps));
draw_set_color(c_white);
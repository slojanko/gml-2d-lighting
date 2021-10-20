if (global.use_new) 
	return;

draw_set_color(c_red);
draw_text(0, 32, src);
draw_text(0, 48, dest);

draw_text(0, 64, "Shadow casters " + string(shadow_casters_count));
draw_text(0, 80, "Lights " + string(lights_count));
draw_text(0, 96, "Shadow vertices " + string(shadow_vertices));
draw_text(0, 112, "Avg render time " + string(profiler.GetAverageTime(ProfilerFormat.ms)) + "ms");
draw_text(0, 128, "Fps " + string(fps));
draw_set_color(c_white);
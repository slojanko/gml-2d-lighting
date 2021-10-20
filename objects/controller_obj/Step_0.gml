if (mouse_check_button_pressed(mb_right)) {
	global.pLightingManager.SetResolution(mouse_x, 720 * (mouse_x / 1280));
	profiler.Reset();
}
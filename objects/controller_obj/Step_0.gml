if (mouse_check_button_pressed(mb_right)) {
	global.pLightingManager.SetResolution(window_mouse_get_x(), 720 * (window_mouse_get_x() / 1280));
	profiler.Reset();
}

if (keyboard_check_pressed(vk_space)) {
	global.pLightingManager.ToggleBlur();
	profiler.Reset();
}
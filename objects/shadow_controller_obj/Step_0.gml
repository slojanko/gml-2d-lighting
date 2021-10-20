src = (src + keyboard_check_pressed(ord("A"))) % 11;
dest = (dest + keyboard_check_pressed(ord("S"))) % 11;

if (keyboard_check_pressed(vk_space)) {
	profiler.Reset();
}
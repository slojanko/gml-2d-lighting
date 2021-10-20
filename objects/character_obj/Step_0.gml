x += 120 * (keyboard_check(ord("D")) - keyboard_check(ord("A"))) * delta_time / 1000000;
y += 120 * (keyboard_check(ord("S")) - keyboard_check(ord("W"))) * delta_time / 1000000;
image_angle = point_direction(x, y, mouse_x, mouse_y);

if (mouse_check_button(mb_left)) {
	var id_ = instance_create_layer(x, y, "Lights", bullet_obj);
	id_.direction = image_angle;
}
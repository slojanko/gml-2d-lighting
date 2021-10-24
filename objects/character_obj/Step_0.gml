x += 120 * (keyboard_check(ord("D")) - keyboard_check(ord("A"))) * delta_time / 1000000;
y += 120 * (keyboard_check(ord("S")) - keyboard_check(ord("W"))) * delta_time / 1000000;
image_angle = point_direction(x, y, mouse_x, mouse_y);

camera_set_view_pos(view_camera[0], x - camera_get_view_width(view_camera[0]) / 2, y - camera_get_view_height(view_camera[0]) / 2);

if (mouse_check_button(mb_left)) {
	var id_ = instance_create_layer(x, y, "Lights", bullet_obj);
	id_.direction = image_angle;
}
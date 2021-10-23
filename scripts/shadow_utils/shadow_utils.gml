function GetRectShadowVertices(){
	var array = array_create(4, 0);
	var matrix = matrix_build(x, y, 0, 0, 0, image_angle, 1, 1, 1);
	
	var transformed;
	transformed = matrix_transform_vertex(matrix, sprite_width-sprite_xoffset, -sprite_yoffset, 0);
	array[0] = new Vec2(transformed[0], transformed[1]);
	transformed = matrix_transform_vertex(matrix, -sprite_xoffset, sprite_height-sprite_yoffset, 0);
	array[1] = new Vec2(transformed[0], transformed[1]);
	transformed = matrix_transform_vertex(matrix, -sprite_xoffset, -sprite_yoffset, 0);
	array[2] = new Vec2(transformed[0], transformed[1]);
	transformed = matrix_transform_vertex(matrix, sprite_width-sprite_xoffset, sprite_height-sprite_yoffset, 0);
	array[3] = new Vec2(transformed[0], transformed[1]);
	
	return array;
}

function GetCircleShadowVertices(precision){
	var half_down = floor(precision / 2);
	var half_up = ceil(precision / 2);
	
	var array = array_create(half_up * 2, 0);
	var matrix = matrix_build(x, y, 0, 0, 0, image_angle, sprite_width, sprite_height, 1);
	
	var transformed;
	for(var i = 0; i < half_up * 2; i+=2) {
		transformed = matrix_transform_vertex(matrix, lengthdir_x(0.5, 360 * (i / precision)) + 0.5 - sprite_xoffset / sprite_width, lengthdir_y(0.5, 360 * (i / precision)) + 0.5 - sprite_yoffset / sprite_height, 0);
		array[i] = new Vec2(transformed[0], transformed[1]);
		
		transformed = matrix_transform_vertex(matrix, lengthdir_x(0.5, 360 * (i + half_down) / precision) + 0.5 - sprite_xoffset / sprite_width, lengthdir_y(0.5, 360 * (i + half_down) / precision) + 0.5 - sprite_yoffset / sprite_height, 0);
		array[i + 1] = new Vec2(transformed[0], transformed[1]);
	}
	
	return array;
}

// TODO: CONVERT TO PAIRS
//function GetPathShadowVertices(path){
//	var point_count = path_get_number(path);
//	var array = array_create(point_count, 0);
//	var matrix = matrix_build(x, y, 0, 0, 0, image_angle, image_xscale, image_yscale, 1);
	
//	var transformed;
//	for(var i = 0; i < point_count; i++) {
//		transformed = matrix_transform_vertex(matrix, path_get_point_x(path, i), path_get_point_y(path, i), 0);
//		array[i] = new Vec2(transformed[0], transformed[1]);
//	}
	
//	return array;
//}
x = xstart + dsin(current_time / 1000 * 60) * 100;
image_xscale = 1 + abs(dsin(current_time / 1000 * 60));
vertices = GetRectShadowVertices();
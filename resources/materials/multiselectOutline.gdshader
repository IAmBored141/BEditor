shader_type canvas_item;
const vec4 outlineColor = vec4(1,1,1,1);

bool isOnOutline(sampler2D tex, vec2 uv, vec2 pixelSize) {
	for (float x = -1.0; x <= 1.0; x++) {
		for (float y = -1.0; y <= 1.0; y++) {
			if (texture(tex, uv+pixelSize*vec2(x,y)).a > 0.0) return true;
		}
	}
	return false;
}

void fragment() {
	if (COLOR.a < 0.5 && isOnOutline(TEXTURE, UV, SCREEN_PIXEL_SIZE)) COLOR = outlineColor;
	else COLOR.a = 0.0;
}

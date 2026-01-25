shader_type canvas_item;
const vec3 multiselectOutline = vec3(1,0,0);
const vec3 componentHoverOutline = vec3(0,1,0);
const vec3 objectHoverOutline = vec3(1,1,0);
const vec3 componentSelectOutline = vec3(0,0,1);
const vec3 objectSelectOutline = vec3(1,0,1);
uniform vec4 testcolor : source_color;

bool isOutlineOf(vec3 color, sampler2D tex, vec2 uv, vec2 pixelSize) {
	for (float x = -1.0; x <= 1.0; x++) {
		for (float y = -1.0; y <= 1.0; y++) {
			if (texture(tex, uv+pixelSize*vec2(x,y)).rgb == color) return true;
		}
	}
	return false;
}

bool isOutline2Of(vec3 color, sampler2D tex, vec2 uv, vec2 pixelSize) {
	for (float x = -2.0; x <= 2.0; x++) {
		for (float y = -2.0; y <= 2.0; y++) {
			if (texture(tex, uv+pixelSize*vec2(x,y)).rgb == color) return true;
		}
	}
	return false;
}

bool approxEqual(vec3 a, vec3 b) {
	return a == b;
	//vec3 result = abs(a - b);
	//return result.r < 0.0035294118 && result.g < 0.0035294118 && result.b < 0.0035294118; // 0.5 / 255
	// this doesnt work for some reason. if you can figure it out, great, but to be honest we probably wont have more than 7 outline types
}

void fragment() {
	COLOR.a = 0.0;
	if (!approxEqual(COLOR.rgb, multiselectOutline)) {
		if (isOutlineOf(multiselectOutline, TEXTURE, UV, SCREEN_PIXEL_SIZE)) COLOR = vec4(1,1,1,1);
		else if (!approxEqual(COLOR.rgb, componentHoverOutline)) {
			if (isOutline2Of(componentHoverOutline, TEXTURE, UV, SCREEN_PIXEL_SIZE)) COLOR = vec4(0,0.63529414,1,0.533000053333336);
			else if (!approxEqual(COLOR.rgb, objectHoverOutline)) {
				if (isOutline2Of(objectHoverOutline, TEXTURE, UV, SCREEN_PIXEL_SIZE)) COLOR = vec4(1,1,1,0.533000053333336);
				else if (!approxEqual(COLOR.rgb, componentSelectOutline)) {
					if (isOutline2Of(componentSelectOutline, TEXTURE, UV, SCREEN_PIXEL_SIZE)) COLOR = vec4(0,0.63529414,1,1);
					else if (!approxEqual(COLOR.rgb, objectSelectOutline)) {
						if (isOutline2Of(objectSelectOutline, TEXTURE, UV, SCREEN_PIXEL_SIZE)) COLOR = vec4(1,1,1,1);
					}
				}
			}
		}
	}
}

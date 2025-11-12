shader_type canvas_item;
instance uniform vec4 colorTop:source_color;
instance uniform vec4 colorBottom:source_color;
instance uniform vec2 size;

vec4 lerpColor(vec4 color1, vec4 color2, float t) {
	return color1 * (1.0-t) + color2 * t;
}

void fragment() {
	vec4 color = lerpColor(colorTop,colorBottom,VERTEX.y/size.y);
	COLOR.rgb = color.rgb;
	COLOR.a *= color.a;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

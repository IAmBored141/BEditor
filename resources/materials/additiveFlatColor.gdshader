shader_type canvas_item;
render_mode blend_add;

varying vec4 modulate;

void vertex() {
	modulate = COLOR;
}

void fragment() {
	COLOR.rgb = modulate.rgb;
	COLOR.a = sign(COLOR.a) * modulate.a;
}

shader_type canvas_item;

float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 hsv(float H, float S, float V){
    //be sure to add up rgb
    float cn = H*0.025;
    //Col is the fully saturated color.
    vec3 col = vec3((float((H>=0.) && (H<40.))*1.)+(float((H>=200.) && (H<240.))*1.)+(float((H>=40.) && (H<80.))*(2.-cn))+(float((H>=160.) && (H<200.))*(cn-4.)),(float((H>=40.) && (H<120.))*1.)+(float((H>=120.) && (H<160.))*(4.-cn))+(float((H>=0.) && (H<40.))*cn),(float((H>=120.) && (H<200.))*1.)+(float((H>=200.) && (H<240.))*(6.-cn))+(float((H>=80.) && (H<120.))*(cn-2.)));
    vec3 gray = vec3(V,V,V);
    col *= V;
    return gray + (col-gray) * S;
}

void fragment() {
	vec4 base = COLOR;
	vec2 uv = floor(UV/TEXTURE_PIXEL_SIZE)*TEXTURE_PIXEL_SIZE;
	float hue = rand(uv+vec2(TIME,0));
	float sat = rand(uv+vec2(0,TIME));
	COLOR = vec4(hsv(240.0*hue,sat*base.r,base.g),base.a);
}
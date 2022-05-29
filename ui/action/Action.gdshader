shader_type canvas_item;

uniform vec4 base_col: hint_color = vec4(0.27, 0.14, 0.05, 1.0);
uniform bool flip = false;

const float PI = 3.1415;

float traperbox(vec2 uv, float wb, float wt, float yb, float yt, float blur) {
	float m = smoothstep(-blur, blur, -uv.y-yb);
	m *= smoothstep(blur, -blur, -uv.y-yt);
	
	uv.x = abs(uv.x);
	
	float w  = mix(wb, wt, (-uv.y - yb) / (yt - yb));
	m *= smoothstep(blur, -blur, uv.x-w);
	
	return m;
}

float arrow_panel(vec2 uv) {
	float t = traperbox(vec2(uv.x, uv.y), 1.0, 0.8, 0, 0.5, 0.001);
	t += traperbox(vec2(uv.x, -uv.y), 1.0, 0.8, 0, 0.5, 0.001);
	return t;
}

void fragment() {
	vec4 col = base_col;
	vec2 uv = UV;
	if (flip) {
		uv.x = 1.0 - uv.x;
	}
	uv -= 0.5;
	float t = arrow_panel(vec2(uv.x+0.5,uv.y));
	col.a = t;
	
	
	t = arrow_panel(vec2(uv.x+0.55, uv.y));
	col.rgb = mix(col.rgb, base_col.rgb * 0.5, 1.0 - t);
	
	t = arrow_panel(vec2(uv.x, uv.y+0.12));
	col.rgb = mix(col.rgb, base_col.rgb * 0.5, 1.0 - t);
//	if (abs(uv.x) < SCREEN_PIXEL_SIZE.x) {
//		col.r = 1.;
//	}
//	if (abs(uv.y) < SCREEN_PIXEL_SIZE.y) {
//		col.g = 1.;
//	}
	
	COLOR = col;
}
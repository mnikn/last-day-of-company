shader_type canvas_item;

uniform vec4 base_col: hint_color = vec4(0.27, 0.14, 0.05, 1.0);
uniform vec2 resolution = vec2(256.0, 64.0);
uniform bool flip = false;

const float PI = 3.1415;

float sat(float t) {
    return clamp(t, 0.0, 1.0);
}

float remap01(float a, float b, float t) {
    return sat((t - a) / (b - a));
}

float remap(float a, float b, float c, float d, float t) {
    return remap01(a, b, t) * (d - c) + c;
}

float polygon(vec2 position, float radius, float sides){
	position = position * 2.0 - 1.0;
	float angle = atan(position.x, position.y);
	float slice = PI * 2.0 / sides;

	return step(radius, cos(floor(0.5 + angle / slice) * slice - angle) * length(position));
}

//vec4 rotate(float angle){
//	return vec4(cos(angle), -sin(angle), sin(angle), cos(angle));
//}

mat2 rotate(float angle){
	return mat2(vec2(cos(angle), -sin(angle)), vec2(sin(angle), cos(angle)));
}

vec2 rotateUVmatrinx(vec2 uv, vec2 pivot, float rotation){
    mat2 rotation_matrix=mat2(  vec2(sin(rotation),-cos(rotation)),
                                vec2(cos(rotation),sin(rotation))
                                );
    uv -= pivot;
    uv= uv*rotation_matrix;
    uv += pivot;
    return uv;
}

float rect(vec2 uv, vec2 size) {
    float blur = 0.000;
    // 让 size 成正比
    size = 0.5 - size * 0.5;
    // 先画一边
    vec2 r = vec2(step(size.x, uv.x), step(size.y, uv.y));
    // 再画相反的边，相乘得出相交位置就是对应的矩形
    r *= vec2(step(size.x, 1.0 - uv.x), step(size.y, 1.0 - uv.y));
    // x 和 y 相乘得出矩形的像素点值
    return r.x * r.y;
}

float circle(vec2 uv, float r) {
    uv -= 0.5;
    uv.x *= resolution.x / resolution.y;
    float blur = 0.005;
    
    // 用 uv 做长度,点距离零点的距离会呈圆形递增
    float d = length(uv);
    d = step(d, r);
    return d;
}


void fragment() {
	vec4 col = base_col;
	vec2 uv = UV;
//	uv.x *= -1.0;
	if (flip) {
		uv.x = 1.0 - abs(uv.x);
	}
	
//    uv = rotateUVmatrinx(uv, vec2(0.5), -45.03);
//	uv = rotateUVmatrinx(UV, vec2(0.52), TIME);
//	uv.x *= -1.0;
	float s = rect(vec2(uv.x+0.2,uv.y), vec2(1.0));
	
	uv -= vec2(0.5);
	uv = rotate(1.57) * uv;
	uv += vec2(0.5);
	s += 1.0 - polygon(vec2(uv.x*0.15+0.2,uv.y+0.45), 0.4, 3);
	s = min(s, 1.0);
	col.a = s;
	
	COLOR = col;
}
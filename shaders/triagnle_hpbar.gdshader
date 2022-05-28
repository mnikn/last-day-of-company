shader_type canvas_item;

const float PI = 3.1415;

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
    // uv.x *= iResolution.x / iResolution.y;
    
    // 用 uv 做长度,点距离零点的距离会呈圆形递增
    float d = length(uv);
    d = step(d,r);
    return d;
}

float polygon(vec2 uv, float radius, float sides) {
	uv = uv * 2.0 - 1.0;
	float angle = atan(uv.x, uv.y);
	float slice = PI * 2.0 / sides;
	return step(radius, cos(floor(0.5 + angle / slice) * slice - angle) * length(uv));
}

vec2 rotate(vec2 uv, vec2 pivot, float rotation) {
    float sine = sin(rotation);
    float cosine = cos(rotation);

    uv -= pivot;
    uv.x = uv.x * cosine - uv.y * sine;
    uv.y = uv.x * sine + uv.y * cosine;
    uv += pivot;

    return uv;
}


float round_rect(vec2 uv, vec2 size) {    
    float radius = size.y/2.0;
    float c1 = circle(vec2(uv.x+0.5-radius*0.5-radius/16.0+(size.x-1.0)*radius*2.0, uv.y), radius);
    float c2 = circle(vec2(uv.x-0.5+radius*0.5+radius/16.0+(1.0-size.x)*radius*2.0, uv.y), radius);
    
    float r = rect(vec2(uv.x, uv.y), vec2(size.x-radius, size.y));


    return min(c1+r+c2, 1.0);
}

void fragment()
{
    // Normalized pixel coordinates (from 0 to 1)
	vec2 uv = UV;
	vec4 coord = FRAGCOORD;
    
    vec3 base_color = vec3(1.0, 0.2, 0.1);

    float osize = 0.1;    
    vec2 size = vec2(1.0, 1.0);
	
    float t = rect(vec2(uv.x+0.1, uv.y), vec2(1.0, 1.0));
//    col *= base_color;
	vec4 col = vec4(vec3(1.0), 1.0);
//	col.a = t;
	
	vec2 arrow_uv = uv;
	arrow_uv *= 0.5;
	arrow_uv.y *= 1.1;
	float arrow = polygon(arrow_uv, 0.3, 3);
	col.a = arrow;
    
    // outline
//    float outline = 1.0 - rect(uv, size - osize);
//    vec3 outline_color = base_color*0.2;
//    col.rgb = mix(col.rgb, outline_color, outline);
    

    // Output to screen
    COLOR = col;
}
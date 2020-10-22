shader_type canvas_item;

//uniform vec4 color : hint_color;
//uniform sampler2D noise_texture : hint_albedo;
//uniform float scroll_speed : hint_range(-10.0, 10.0, 0.1);
//uniform float flash_interval : hint_range(0.0, 10.0, 1.0);
//
//float remap_value(float v, float input_min, float input_max, float output_min, float output_max) {
//	v = clamp(v, input_min, input_max);
//	return output_min + (v - input_min) * (output_max - output_min)/(input_max - input_min);
//}
//
//void fragment(){
//	vec4 tex = texture(TEXTURE, UV);
//	vec2 coord = SCREEN_UV;
//
//	vec4 noise = texture(noise_texture, vec2(coord.x - TIME * scroll_speed, coord.y));
//	float intensity = remap_value(cos(TIME * flash_interval), -1.0, 1.0, 0.5, 0.9);
//	float flash = tex.a * (noise.r + intensity);
//	COLOR = vec4(color.rgb, flash);
//}

uniform float intensity = 0.5f;
uniform float layers = 5f;
uniform float speed = 4f;

uniform float size_x = 0.008;
uniform float size_y = 0.008;

//void fragment(){
//
//}

float gradient(vec2 uv){
	return (0.5f - distance(vec2(0f, uv.y), vec2(0f, 0.5f)));
	return (1f - distance(vec2(0f, uv.y), vec2(0f, 0f)));
	return (1f - distance(vec2(0f, uv.y), vec2(0f, 1f)));
	return (0.5f - distance(vec2(uv.x, uv.y), vec2(0.5, 0.5)));
}

vec4 colorize(float c, float a){
	vec4 palette;
	palette = vec4(c, c, c, a);
	palette.r = float(c >= 1f);
	return palette;
}

void fragment(){
	vec2 uv = SCREEN_UV;
	uv -= mod(uv, vec2(size_x, size_y));
	vec4 bg = texture(TEXTURE, UV - TIME / speed);
	COLOR.r = gradient(UV);
	COLOR.r = clamp(COLOR.r * bg.r * intensity * 10f, 0f, 1f);
	COLOR.r = floor(COLOR.r * layers) / layers;
	COLOR.a = float(COLOR.r > 0f);
	COLOR = colorize(COLOR.r, COLOR.a);
	
	
//	COLOR.rgb = textureLod(TEXTURE, uv, 0.0).rgb;
}

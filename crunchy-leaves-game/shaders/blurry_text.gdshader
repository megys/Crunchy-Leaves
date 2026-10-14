// BLURRED TEXT SHADER
// adapts the dual kawase blurs for labels. can be used as a child node to create a drop shadow effect.
// use the self_modulate / modulate properties in the editor to control colours
// https://godotshaders.com/shader/dual-kawase-up-fast-blur/

shader_type canvas_item;

#define BLUR_DOWN 0
#define BLUR_UP   1

uniform float offset : hint_range(0.0, 10.0);
uniform int mode = 0; // Type 0 or 1 in the Inspector

varying vec4 modulate;

void vertex() {
	modulate = COLOR;
}

void fragment() {
	vec2 uv = UV;
	vec2 halfpixel = TEXTURE_PIXEL_SIZE / 2.0;
	
	vec4 sum;
	vec4 temp;
	
	if ( mode == BLUR_DOWN ) {
		sum = texture(TEXTURE, uv) * 4.0;
		sum += texture(TEXTURE, uv - halfpixel.xy * offset);
		sum += texture(TEXTURE, uv + halfpixel.xy * offset);
		sum += texture(TEXTURE, uv + vec2(halfpixel.x, -halfpixel.y) * offset);
		sum += texture(TEXTURE, uv - vec2(halfpixel.x, -halfpixel.y) * offset);
		temp = sum / 8.0;
	} else if ( mode == BLUR_UP ) {
		sum = texture(TEXTURE, uv + vec2(-halfpixel.x * 2.0, 0.0) * offset);
		sum += texture(TEXTURE, uv + vec2(-halfpixel.x, halfpixel.y) * offset) * 2.0;
		sum += texture(TEXTURE, uv + vec2(0.0, halfpixel.y * 2.0) * offset);
		sum += texture(TEXTURE, uv + vec2(halfpixel.x, halfpixel.y) * offset) * 2.0;
		sum += texture(TEXTURE, uv + vec2(halfpixel.x * 2.0, 0.0) * offset);
		sum += texture(TEXTURE, uv + vec2(halfpixel.x, -halfpixel.y) * offset) * 2.0;
		sum += texture(TEXTURE, uv + vec2(0.0, -halfpixel.y * 2.0) * offset);
		sum += texture(TEXTURE, uv + vec2(-halfpixel.x, -halfpixel.y) * offset) * 2.0;
		temp = sum / 12.0;
	}

	COLOR.a = temp.a * modulate.a;
}

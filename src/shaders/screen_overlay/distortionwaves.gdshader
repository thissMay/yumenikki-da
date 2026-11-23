shader_type canvas_item;

#include "res://src/shaders/_include/depth_base.gdshaderinc"
group_uniforms DistortionWaves;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float noise_strength : hint_range(-0.085, 1, 0.01 ) = 0.025;
uniform sampler2D noise_fwd : repeat_enable;

uniform float scroll_speed = 1.0;


void vertex()
{
	UV = _depth_vertex(UV, TEXTURE_PIXEL_SIZE);
}

void fragment()
{
	vec2 uv = SCREEN_UV;
	vec2 scroll_dir = -vec2(scroll_speed / 2.);
	vec4 panorama = texture(screen_texture, uv);

	vec4 noise_scroll_fwd = texture(noise_fwd, uv + vec2(TIME * (scroll_dir)));
	vec4 wave_effect =  texture(screen_texture, uv + scroll_speed * (noise_scroll_fwd.xy * noise_strength * (vec2(noise_scroll_fwd.x,  noise_scroll_fwd.y))) * noise_strength);

		COLOR = vec4
		(
			wave_effect.r,
			wave_effect.g,
			wave_effect.b,
			wave_effect.a
		);
}
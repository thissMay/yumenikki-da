shader_type canvas_item;

#include "res://src/shaders/_include/general_base.gdshaderinc"
#include "res://src/shaders/_include/linear_base.gdshaderinc"
#include "res://src/shaders/_include/depth_base.gdshaderinc"

uniform bool texture_scroll = false;

uniform float noise_strength : hint_range(-0.085, 1, 0.01 ) = 0.025;
uniform sampler2D noise : repeat_enable;

void vertex()
{
	UV =  _depth_vertex(UV, TEXTURE_PIXEL_SIZE);
}

void fragment()
{
	vec2 uv = UV;
	vec2 scroll_dir = -vec2(dirX, dirY) * (scroll_speed / 2.);

	vec4 noise_scroll_fwd = texture(noise, uv + vec2(TIME * (scroll_dir)));
	vec4 wave_effect =  texture(TEXTURE, uv + scroll_speed * ((vec2(noise_scroll_fwd.x,  noise_scroll_fwd.y)) * noise_strength * (vec2(noise_scroll_fwd.x,  noise_scroll_fwd.y))) * noise_strength);

	COLOR.rgb = wave_effect.rgb;
	COLOR.a = wave_effect.a - transparency;
}
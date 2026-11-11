
shader_type canvas_item;
render_mode blend_add;

#include "res://src/shaders/_include/depth_base.gdshaderinc"

uniform float opacity : hint_range(0.0, 1.0, 0.1) = 1;
uniform sampler2D noise : repeat_enable;

uniform float scroll_speed : hint_range(-0.085, 0.085, 0.01 ) = 0.05;

uniform sampler2D gradient;
uniform float rot_radians = 0;

uniform float ray_strength = 1.225;

void vertex()
{
	UV = _depth_vertex(UV, TEXTURE_PIXEL_SIZE);
	UV = mat2( 
		vec2(cos(rot_radians), sin(rot_radians)), 
		vec2(-sin(rot_radians), cos(rot_radians)) ) * (UV / 2.);



	UV.y = UV.y * 1.1;
}

void fragment()
{
	vec4 noise_scroll_fwd = texture(
		noise, 
		vec2(
			UV.x + (TIME * scroll_speed), 
			UV.y * .4)
		);
	
	vec4 noise_scroll_back = texture(
		noise, 
		vec2(
			UV.x + -(TIME * scroll_speed / 1.2), 
			UV.y * .1)
		);

	COLOR.rgb = (noise_scroll_fwd * noise_scroll_back).rgb * texture(gradient, UV * 2.).rgb;
	COLOR.a = opacity / (ray_strength / 3.);


}

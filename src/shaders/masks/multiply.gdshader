shader_type canvas_item;
render_mode blend_mul;

#include "res://src/shaders/_include/general_base.gdshaderinc"


void fragment()
{
	COLOR.rgb = texture(gradient, UV).rgb;
	COLOR.a = 1. - transparency;
}
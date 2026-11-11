shader_type canvas_item;
render_mode unshaded;
#include "res://src/shaders/_include/transition_base.gdshaderinc"

uniform vec4 colour : source_color;
uniform float width;
uniform float height;

void fragment() {
	COLOR = colour * vec4(vec2(width, width), vec2(height, height));
}
# ---- 	CUSTOM PANEL HIERARCHY 	----
# -> Control
# 	-> Main Container
# 		-> Display BG
#		-> Margin Container
#			-> Icon Content Seperator
#				-> Icon Display Container
#				-> Icon Display
#				-> Inner Main Container
#					-> Text Display
# ----							----

@tool

class_name GUIPanel
extends Control

@export_category("Panel Properties")
var resize_tweener: Tween

# ---- constants ----

const MIN_SIZE := Vector2(60, 18)
const DEFAULT_PANEL_DISPLAY_SHADER: Shader = preload("res://src/shaders/ui/button_texture_grad_mask.gdshader")
const DEFAULT_DISPLAY_BG_COLOR = Color(1,1,1,0)

# ---- size control ----
# ---- common vars ----
@export_group("Panel Visuals")
@export var panel_stylebox_override: StyleBoxTexture:
	set(_ov):
		panel_stylebox_override = _ov
		if main_container != null: 
			if _ov: main_container.add_theme_stylebox_override("panel", _ov)
			else: main_container.remove_theme_stylebox_override("panel")
@export var panel_display_colour: Color = DEFAULT_DISPLAY_BG_COLOR
@export var panel_display_shader: Shader = DEFAULT_PANEL_DISPLAY_SHADER

# ---- inner button components ---- 
@export var display_bg: ColorRect

@export var main_container: PanelContainer
@export var inner_main_container: CenterContainer
@export var icon_content_seperator: BoxContainer

@export var margin_container: MarginContainer
@export var icon_display_container: CenterContainer
@export var icon_display: TextureRect

@export var text_display: Label

func _children_components_setup() -> void:
	main_container = Utils.get_child_node_or_null(self, "main_container")
	
	display_bg = Utils.get_child_node_or_null(self.main_container, "display_bg")
	margin_container = Utils.get_child_node_or_null(self.main_container, "margin_container")
	
	icon_content_seperator = Utils.get_child_node_or_null(self.margin_container, "icon_content_seperator")
	
	icon_display_container = Utils.get_child_node_or_null(self.icon_content_seperator, "icon_display_container")
	inner_main_container = Utils.get_child_node_or_null(self.icon_content_seperator, "inner_main_container")
	
	icon_display = Utils.get_child_node_or_null(self.icon_display_container, "icon_display")
	text_display = Utils.get_child_node_or_null(self.inner_main_container, "text_display")
	
	# --- 
	
	if main_container == null: main_container = Utils.add_child_node(self, PanelContainer.new(), "main_container")
	
	if display_bg == null: display_bg = Utils.add_child_node(self.main_container, ColorRect.new(), "display_bg")
	if margin_container == null: margin_container = Utils.add_child_node(self.main_container, MarginContainer.new(), "margin_container")
	
	if icon_content_seperator == null: icon_content_seperator = Utils.add_child_node(self.margin_container, HBoxContainer.new(), "icon_content_seperator")
	
	if icon_display_container == null: icon_display_container = Utils.add_child_node(self.icon_content_seperator, CenterContainer.new(), "icon_display_container")
	if inner_main_container == null: inner_main_container = Utils.add_child_node(self.icon_content_seperator, CenterContainer.new(), "inner_main_container")
	
	if icon_display == null: icon_display = Utils.add_child_node(self.icon_display_container, TextureRect.new(), "icon_display")
	if text_display == null: text_display = Utils.add_child_node(self.inner_main_container, Label.new(), "text_display")

func _ready() -> void:
	_children_components_setup()
	_core_setup()
	_additional_setup()

func _additional_setup() -> void: pass
func _core_setup() -> void:
	self.custom_minimum_size = MIN_SIZE
	main_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
	text_display.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text_display.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text_display.label_settings = preload("res://themes/global_label_settings.tres")
	
	icon_display_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon_content_seperator.mouse_filter = Control.MOUSE_FILTER_IGNORE
	inner_main_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	display_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon_display.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text_display.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	margin_container.add_theme_constant_override("margin_top", 2)
	margin_container.add_theme_constant_override("margin_bottom", 2)
	margin_container.add_theme_constant_override("margin_right", 4)
	margin_container.add_theme_constant_override("margin_left", 4)
	
	display_bg.size_flags_horizontal = true
	display_bg.size.y = main_container.size.x
	display_bg.size.y = main_container.size.y
		
	display_bg.material = ShaderMaterial.new()
	display_bg.material.shader = DEFAULT_PANEL_DISPLAY_SHADER
	if theme == null: theme = preload("res://themes/global_theme.tres")
	set_panel_modulate(panel_display_colour)
	
# --- setter functions ---	

func set_panel_modulate(_modu: Color) -> void:
	display_bg.color = _modu

# --- transform functions --

func resize_panel(new_size: Vector2) -> void: 
	display_bg.size = new_size

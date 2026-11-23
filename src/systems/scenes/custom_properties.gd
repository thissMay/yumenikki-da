@icon("res://addons/miscallenous/editor/custom_properties.png")
@tool

class_name CustomNodeProperties
extends Node

const PROPERTIES_SAVER_ID := "save_properties"

@export var properties: Dictionary = {}
@export var properties_saver: NodePropertiesSave

@export_group("Flags")
@export var skip_save: bool = false:
	set = __set_skip_save
@export var global_data: bool = false

func _ready() -> void:
	set_process			(false)
	set_physics_process	(false)
	set_process_input	(false)

	if Engine.is_editor_hint():
		__set_skip_save(skip_save)
func _validate_property(property: Dictionary) -> void:
	if 	property.name == "properties_saver":
		property.usage = PROPERTY_USAGE_NO_EDITOR 

func __set_skip_save(_skip: bool) -> void:
	skip_save = _skip
	match _skip:
		true: 
			properties_saver = Utils.get_child_node_or_null(self, PROPERTIES_SAVER_ID)
			if properties_saver != null: 
				properties_saver.free()
				properties_saver = null
		false: 
			properties_saver = Utils.get_child_node_or_null(self, PROPERTIES_SAVER_ID)
			if properties_saver == null:
				properties_saver = Utils.add_child_node(self, NodePropertiesSave.new(), PROPERTIES_SAVER_ID)
				properties_saver.properties.append("properties")

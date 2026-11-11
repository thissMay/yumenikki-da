@tool

class_name EVN_SetProperty
extends Event

const DUPLICATIVE_TYPES := [
	TYPE_ARRAY, TYPE_DICTIONARY, 
	TYPE_PACKED_COLOR_ARRAY, TYPE_PACKED_FLOAT32_ARRAY, TYPE_PACKED_INT32_ARRAY,
	TYPE_PACKED_STRING_ARRAY]


@export_group("Info.")
@export var node: Node
@export var property_name: String = "":
	set(_name): 
		property_name = _name
		if Engine.is_editor_hint():
			property_info = search_property(node, _name)
@export var property_info: Dictionary = {
	"name"			: "default",
	"type"			: TYPE_NIL,
	"hint"			: PROPERTY_HINT_NONE,
	"hint_string"	: "",
	"usage" 		: PROPERTY_USAGE_NONE}

@export_group("Values.")
var property_exists_in_node: bool = false
@export_storage var property_value: Variant
@export_storage var new_value: 		Variant

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT

func _get_property_list():
	var properties = [{
			"class_name"	: "",
			"name"			: "default",
			"type"			: TYPE_NIL,
			"hint"			: PROPERTY_HINT_NONE,
			"hint_string"	: "",
			"usage" 		: PROPERTY_USAGE_NONE}]
	
	if property_info == {}:
		property_exists_in_node = false 
		return properties
	
	property_exists_in_node = true
	return properties
func _validate_property(property: Dictionary) -> void:
	if Engine.is_editor_hint():
		var adaptable_properties: PackedStringArray = [
			"property_value",
			"new_value"
			]
		if property_exists_in_node:
			if property["name"] in adaptable_properties : 
				property["type"] 		= property_info["type"]
				property["usage"] 		= PROPERTY_USAGE_DEFAULT # otherwise we show em.
		else:
			if property["name"] in adaptable_properties : 
				property["usage"] = PROPERTY_USAGE_NONE
			
func search_property(_node: Node, _name: String) -> Dictionary:
	if _node == null: 
		property_exists_in_node = false
		return {}
		
	for i in _node.get_property_list():
		if _name == i["name"]: 
			property_exists_in_node = true
			property_value = node.get_indexed(_name)
			
			var value_type = typeof(property_value) 
			
			match value_type:
				TYPE_DICTIONARY:	new_value = property_value.duplicate(true)
				TYPE_ARRAY:			new_value = property_value.duplicate(true)
				_: 					new_value = property_value
					
			return i
	
	property_exists_in_node = false
	return {}

func _execute() -> void:
	print(self, ":: old  value -- ", property_value)
	print(self, ":: new value -- ", new_value)
	node.set(property_name, new_value)
	print(self, ":: ", node.get_indexed(property_name))

func _valdiate() -> bool:
	return node != null
	

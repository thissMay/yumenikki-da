@tool
class_name EVN_CallFunction
extends Event

signal method_changed
var method_exists_in_node: bool = false

@export_category("Call Function Info")
@export_group("Info.")
@export var node: Node
@export_placeholder("e.g.: func_name") var method_name: String = "":
	set(_name):
		method_name = _name
		if Engine.is_editor_hint():
			method_info = search_method(node, _name)
@export var method_info: Dictionary = {
		"name"			: "",
		"args"			: [],
		"default_args"	: [],
		"flags"			: METHOD_FLAG_NORMAL,
		"id"			: 0,
		"return" 		: {}}

@export_group("Additional.")
@export var new_process_mode: ProcessMode = 0
@export var change_process_mode: bool = false
var old_process_mode: ProcessMode = 0

var all_methods: Array[Dictionary] = [{}]
var internal_args: Dictionary[String, Variant] = {}

func _ready() -> void:
	if node == null: return
func _execute() -> void: 
	old_process_mode = node.process_mode
	
	if change_process_mode:	node.process_mode = new_process_mode
	node.callv(method_name, internal_args.values())
	if change_process_mode:	node.process_mode = old_process_mode
	
func _validate() -> bool:
	if node == null: return false 
	if !node.has_method(method_name): return false
	return true

func search_method(_node: Node, _name: String) -> Dictionary:
	
	if _node == null: 
		method_exists_in_node = false
		return {}
		
	for i in _node.get_method_list():
			if _name == i["name"]: 
				method_exists_in_node = true
				internal_args.clear()
				return i
	
	new_process_mode = _node.process_mode
	method_exists_in_node = false
	return {}

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = [{
			"name"			: "Exposed Method Arguments",
			"type"			: TYPE_NIL,
			"hint"			: PROPERTY_HINT_NONE,
			"hint_string"	: "",
			"usage" 		: PROPERTY_USAGE_CATEGORY}]
			
	properties.append({
			"name"			: "internal_args",
			"type"			: TYPE_DICTIONARY,
			"hint"			: PROPERTY_HINT_NONE,
			"hint_string"	: "",
			"usage" 		: PROPERTY_USAGE_STORAGE | PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_READ_ONLY})
	
	if method_info == {}:
		method_exists_in_node = false 
		return properties
	
	for i in method_info["args"]:
	
		if i["type"] == TYPE_OBJECT and !i["class_name"].is_empty():
			i["hint"] = PROPERTY_HINT_NODE_TYPE

		properties.append(
			{
				"class_name" : i["class_name"],
				"name" : i["name"],
				"hint" : i["hint"],
				"type" : i["type"],
				"usage" : PROPERTY_USAGE_EDITOR,
			})
		
	method_exists_in_node = true
	return properties

	
func _set(_property: StringName, _value: Variant) -> bool:
	if !method_exists_in_node: return false

	for arg in method_info["args"]:

		if _property == arg["name"]:
			internal_args[_property] = _value
			return true

	return false

func _get(_property: StringName):
	if internal_args.has(_property): return internal_args[_property]

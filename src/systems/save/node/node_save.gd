@abstract
class_name NodeSave
extends Node

@export var global: bool = false
var data: Dictionary = {}
var parent: Node = null

func _ready() -> void:
	add_to_group(SceneSaver.NODE_SAVE_GROUP_ID)
	
func save_data() 					-> Dictionary: return data
func load_data(_scene: SceneNode) 	-> Error: return OK

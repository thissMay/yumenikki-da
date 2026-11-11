@tool

class_name SceneNode
extends StackNode

var initialized: 	bool = false
var pushed:			bool = false

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_SCENE_INSTANTIATED:
			if Engine.is_editor_hint(): process_mode = Node.PROCESS_MODE_INHERIT
			else: 						process_mode = Node.PROCESS_MODE_DISABLED
			
		NOTIFICATION_READY:
			add_to_group("scene_node")

func _on_pop() -> void:
	queue_free()
func _on_pre_pop() -> void: 
	set_process_mode.call_deferred(Node.PROCESS_MODE_DISABLED)
func _on_push() -> void: 
	set_process_mode.call_deferred(Node.PROCESS_MODE_INHERIT)

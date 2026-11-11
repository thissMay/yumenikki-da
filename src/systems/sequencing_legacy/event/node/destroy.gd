extends Event
@export var node: Node

func _execute() -> void: node.queue_free()
func _validate() -> bool: return node != null	

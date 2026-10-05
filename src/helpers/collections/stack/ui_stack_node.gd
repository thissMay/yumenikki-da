class_name UIStackNode
extends StackNode

@export var control: Array[Control]

func _ready() -> void: self.visibility_changed.connect(get_focus)
func _on_push() -> void: get_focus()
func _on_pop() -> void: lose_focus()
	
func get_focus() -> void: 
	if self.visible:
		if control.is_empty(): return
		if control[0] != null: control[0].grab_focus()
func lose_focus() -> void:
	if control.is_empty(): return
	if control[0] != null: control[0].release_focus()

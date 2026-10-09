@abstract

class_name ButtonDecorationComponent
extends Control

var parent: BaseButton

func _ready() -> void:
	parent = get_parent()
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	show_behind_parent = true
	
	if (parent == null or parent is not BaseButton): return
	
	(parent as Button).flat = true
	(parent as BaseButton).focus_entered.connect(hover_anim)
	(parent as BaseButton).focus_exited.connect(unhover_anim)
	(parent as BaseButton).button_down.connect(press_anim)

@abstract	
func hover_anim() -> void

@abstract
func unhover_anim() -> void

@abstract
func press_anim() -> void

@abstract
func validate() -> bool

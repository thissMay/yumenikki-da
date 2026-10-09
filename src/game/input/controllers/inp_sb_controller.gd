class_name SBInputController
extends InputController

var actor: Actor2D

func _setup(_sb: Actor2D = null) -> void: 
	if _sb == null: return
	actor 		= _sb

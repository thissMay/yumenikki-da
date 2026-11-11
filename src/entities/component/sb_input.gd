class_name SBInput
extends SBComponent


func _setup(_sb: Actor2D = null) -> void: 
	super(_sb)
	if _sb is Player2D: 
		InputManager.sb_input_controller._setup(_sb)

func _update(_delta: float) -> void:
	actor.signal_input.emit(InputManager.dir_input)

func _on_bypass_enabled() -> void:
	actor.vel_input = Vector2.ZERO
	actor.dir_input = Vector2.ZERO

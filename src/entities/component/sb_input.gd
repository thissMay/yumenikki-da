class_name SBInput
extends SBComponent


func _setup(_sb: Actor2D = null) -> void: 
	super(_sb)
	if _sb is Player: 
		InputManager.sb_input_controller._setup(_sb)

func _input_pass(_input: InputEvent) -> void:
	if 		_input.is_action_pressed ("pl_sprint"): (actor as Player).quered_sprint_start.emit()
	elif 	_input.is_action_released("pl_sprint"): (actor as Player).quered_sprint_end.emit()
		
	if 		_input.is_action_pressed ("pl_sneak"): 	(actor as Player).quered_sneak_start.emit()
	elif 	_input.is_action_released("pl_sneak"):  (actor as Player).quered_sneak_end.emit()

func _update(_delta: float) -> void:
	actor.input_vector.emit(InputManager.dir_input)

func _on_bypass_enabled() -> void:
	actor.vel_input = Vector2.ZERO
	actor.dir_input = Vector2.ZERO

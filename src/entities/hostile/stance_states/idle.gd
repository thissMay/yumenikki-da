extends SBState

func _state_enter() -> void: 
	(actor as Actor2D).velocity = Vector2.ZERO
	super()

func _state_physics_update(_delta: float) -> void:
	if actor.speed > 0: request_transition_to("walk")
	

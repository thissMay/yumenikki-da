extends SBState


func _state_physics_update(_delta: float) -> void:
	if actor.speed <= 0: request_transition_to("idle")
	elif actor.speed > actor.speed * actor.speed_multiplier: 
		request_transition_to("sprint")
	
	actor.speed_multiplier = 1

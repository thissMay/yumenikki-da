extends SBState

func physics_update(delta: float) -> void:
	if actor.desired_speed <= 0: request_transition_to("idle")
	actor.speed_multiplier = 2

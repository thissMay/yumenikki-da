extends SBState

var target: Actor2D

func physics_update(_delta: float) -> void:
	if target == null: return
	actor.handle_direction((target.global_position - actor.global_position))

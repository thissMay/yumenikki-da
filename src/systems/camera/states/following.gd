extends LegacyState

func _state_update(_delta: float) -> void:
	context.curr_strat._follow(
		context, 
		context.curr_target.global_position)

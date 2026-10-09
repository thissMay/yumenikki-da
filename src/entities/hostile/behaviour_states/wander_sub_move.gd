extends SBState

func _state_physics_update(_delta: float) -> void: 
	actor.handle_velocity()
	actor.handle_heading()
	
	if !(actor as NavSentient).nav_agent.is_target_reached() and \
		(actor as NavSentient).nav_agent.is_target_reachable():

		actor.handle_direction(
			(actor as NavSentient).nav_agent.get_next_path_position() - actor.global_position)
		
		actor.vel_input = actor.direction
	
	else:
		request_transition_to("wander_idle")

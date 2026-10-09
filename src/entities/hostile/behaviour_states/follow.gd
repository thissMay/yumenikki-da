extends SBState

@export var path_update_timer: Timer
@export var stance_fsm: SentientFSM
var target: Actor2D

func _state_enter() -> void: 
	if target == null: return
	(actor as NavSentient).nav_agent.target_desired_distance = 32.5
	(actor as NavSentient).nav_agent.target_position = target.global_position
	super()

func physics_update(_delta: float) -> void: 
	if target == null: return
	(actor as NavSentient).nav_agent.target_position = target.global_position
	
	if (actor as NavSentient).nav_agent.is_navigation_finished() or (actor as NavSentient).nav_agent.is_target_reached():
		if stance_fsm == null: return
		stance_fsm.change_to_state("idle")
	else:
		(actor as NavSentient).handle_direction((actor as NavSentient).nav_agent.get_next_path_position() - actor.global_position)
		actor.handle_direction((actor as NavSentient).nav_agent.get_next_path_position() - actor.global_position)

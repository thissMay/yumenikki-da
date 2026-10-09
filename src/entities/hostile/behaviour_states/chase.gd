extends SBState

@export var stance_fsm: SentientFSM
@export var sb_aggression: SBAggression
var target: Actor2D

func _state_enter() -> void:
	if sb_aggression.emits_chase_sequence:
		EventManager.invoke_event("CHASE_ACTIVE")
		
	(actor as NavSentient).nav_agent.set_navigation_layer_value(2, false)
	(actor as NavSentient).nav_agent.set_navigation_layer_value(3, true)
	
	(actor as NavSentient).nav_agent.target_desired_distance = 20.75
	actor.handle_direction((actor as NavSentient).nav_agent.get_next_path_position() - actor.global_position)
	super()

func _state_exit() -> void:
	if sb_aggression.emits_chase_sequence:
		EventManager.invoke_event("CHASE_FINISH")

func physics_update(_delta: float) -> void: 
	if (actor as NavSentient).nav_agent.is_target_reachable():
		
		actor.handle_direction((actor as NavSentient).nav_agent.get_next_path_position() - actor.global_position)
		actor.handle_direction((actor as NavSentient).nav_agent.get_next_path_position() - actor.global_position)
		update_chase_point()
	
	else:
		stance_fsm.change_to_state("idle")
		update_chase_point()

func update(_delta: float) -> void:
	if sb_aggression.suspicion <= 50:
		sb_aggression.suspicion = 20
		fsm.change_to_state("observe")

func update_chase_point() -> void: 
	actor.nav_agent.target_position = target.global_position

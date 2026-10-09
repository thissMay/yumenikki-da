extends SBState

@export var stance_fsm: SentientFSM
@export var sb_aggression: SBAggression
@export var hesitance_timer: Timer

@export var min_wait_time: float = 1
@export var max_wait_time: float = 1.5

@export var hesitance_distance: float = 50

var target: Actor2D
var roll: float = 0

func _setup() -> void:
	if sb_aggression == null: return
	hesitance_timer.wait_time = randf_range(min_wait_time, max_wait_time)
	hesitance_timer.autostart = false
	hesitance_timer.one_shot = true

	hesitance_timer.timeout.connect(func():
		stance_fsm.change_to_state("idle")	
		hesitance_timer.wait_time = randf_range(min_wait_time, max_wait_time)
		update_hesitance_observe_point())
		
	(actor as NavSentient).nav_agent.target_reached.connect(hesitance_timer.start)

func _state_enter() -> void:
	roll = randf()
	 		
	target = sb_aggression.target
	sb_aggression.suspicion_indicator_status.visible = true
	sb_aggression.suspicion_indicator_status.progress = 0
	
	(actor as NavSentient).nav_agent.target_desired_distance = 10
	(actor as NavSentient).nav_agent.set_navigation_layer_value(2, false)
	(actor as NavSentient).nav_agent.set_navigation_layer_value(3, true)
	hesitance_timer.start()
	super()
	
func _state_exit() -> void: 
	
	sb_aggression.suspicion_indicator_status.visible = false
	hesitance_timer.stop()
	super()
	
func update(_delta: float) -> void:
	if sb_aggression.suspicion > sb_aggression.min_chase_threshold:
		if fsm._has_state("taunt") and roll >= sb_aggression.taunt_chance: 
			fsm.change_to_state("taunt")
		
		else: 
			fsm.change_to_state("chase")
			
	if sb_aggression.suspicion < 10:
		fsm.change_to_state("wander")
		
func physics_update(_delta: float) -> void: 
	if (!(actor as NavSentient).nav_agent.is_target_reached() and 
		(actor as NavSentient).nav_agent.is_target_reachable()):
			
		actor.handle_direction((actor as NavSentient).nav_agent.get_next_path_position() - actor.global_position)
		actor.handle_direction((actor as NavSentient).nav_agent.get_next_path_position() - actor.global_position)
	
	else:
		stance_fsm.change_to_state("idle")	
		
	if !(actor as NavSentient).nav_agent.is_target_reachable():
		update_hesitance_observe_point()

func update_hesitance_observe_point() -> void: 
	actor.nav_agent.target_position = target.global_position

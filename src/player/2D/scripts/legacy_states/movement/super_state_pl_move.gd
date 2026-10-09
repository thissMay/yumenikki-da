extends SBNestedState

func _setup_sub_state() -> void:
	Utils.connect_to_signal(handle_to_sprint, actor.quered_sprint_start)
	Utils.connect_to_signal(handle_to_sneak, actor.quered_sneak_start)
	
	Utils.connect_to_signal(handle_to_walk, actor.quered_sprint_end)
	Utils.connect_to_signal(handle_to_walk, actor.quered_sneak_end)

func _enter_sub_state() -> void: 
	set_sub_state("walk")

func _update_sub_state(_delta: float) -> void:
	if actor.desired_speed <= 0: 
		request_transition_to("idle")
	
func _physics_update_sub_state(_delta: float) -> void:
	actor.handle_heading()
	actor.handle_velocity()


func handle_to_sprint() -> void:	if actor.values.can_sprint: set_sub_state("sprint")
func handle_to_sneak() -> void: 	if actor.values.can_sneak:  set_sub_state("sneak")
func handle_to_walk() -> void: 								set_sub_state("walk")
	

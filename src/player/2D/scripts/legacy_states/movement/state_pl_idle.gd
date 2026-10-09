extends SBState
var library_path := "normal"

func _state_enter() -> void: 
	actor.handle_heading()
	actor.noise_multi = 0
	actor.velocity = Vector2.ZERO
	actor.speed_multiplier = 1
	
	actor.components.get_component_by_name("animation_manager").play_animation(str(library_path, '/', "idle"))

func _state_update(_delta: float) -> void:
	if actor.desired_speed > 0:
		request_transition_to("move")
	
func _state_physics_update(_delta: float) -> void:
	actor.get_behaviour()._idle(actor, _delta)

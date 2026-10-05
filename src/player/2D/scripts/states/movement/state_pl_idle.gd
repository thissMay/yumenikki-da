extends SBState
var library_path := "normal"

func _state_enter() -> void: 
	sentient.handle_heading()
	sentient.noise_multi = 0
	sentient.velocity = Vector2.ZERO
	sentient.speed_multiplier = 1
	
	sentient.components.get_component_by_name("animation_manager").play_animation(str(library_path, '/', "idle"))

func _state_update(_delta: float) -> void:
	if sentient.desired_speed > 0:
		request_transition_to("move")
	
func _state_physics_update(_delta: float) -> void:
	sentient.get_behaviour()._idle(sentient, _delta)

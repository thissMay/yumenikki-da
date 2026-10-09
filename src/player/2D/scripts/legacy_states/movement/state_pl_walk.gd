extends SBState
var library_path := "normal"

func _state_enter() -> void:
	actor.components.get_component_by_name("animation_manager").play_animation(str(library_path, '/', "walk"))

func _state_update(_delta: float) -> void:
	if actor.values.auto_sprint: 
		request_transition_to("sprint")

func _state_physics_update(_delta: float) -> void:
	actor.get_behaviour()._walk(actor, _delta)
	

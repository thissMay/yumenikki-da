extends SBState

@export var sb_sprint: SBSprint
var library_path := "normal"

func _state_enter() -> void: 	
	actor.components.get_component_by_name("animation_manager").play_animation(str(library_path, '/', "run"))

func _state_update(_delta: float) -> void:
	if !actor.values.can_sprint:
		request_transition_to("walk")

func _state_physics_update(_delta: float) -> void:
	actor.get_behaviour()._run(actor, _delta)

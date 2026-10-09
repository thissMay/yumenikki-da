extends SBState
var library_path := "normal"
	
func _state_enter() -> void: 
	(actor as Player_YN).set_texture_using_sprite_sheet("walk")
	actor.components.get_component_by_name("animation_manager").play_animation(str(library_path, '/', "walk"))

func _state_update(_delta: float) -> void:
	if !actor.values.can_sneak:
		request_transition_to("walk")

func _state_physics_update(_delta: float) -> void:	
	actor.get_behaviour()._sneak(actor, _delta)
	

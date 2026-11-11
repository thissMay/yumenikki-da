extends PLAction

@export var pinch_animation: StringName = &"action/pinch"
@export_file("*.tscn") var return_location: String = ""
var pinch_progress: float = 0:
	set(_progress):
		pinch_progress = clampf(_progress, 0, 1) 

func _perform(_pl: Player2D) -> void:
	pinch_progress = 0
	
	_pl.vel_input = Vector2.ZERO
	_pl.dir_input = Vector2.ZERO
	_pl.velocity = Vector2.ZERO
	
	_pl.deequip_effect()
	_pl.force_change_state("action")
	
	_pl.components.get_component_by_name(Player2D.Components.ANIMATION).play_animation(pinch_animation, 0)
	
func _action_update			(_pl: Player2D, _delta: float) -> void:
	_pl.components.get_component_by_name(Player2D.Components.ANIMATION).seek(
		pinch_progress * \
		_pl.components.get_component_by_name(Player2D.Components.ANIMATION).get_animation(pinch_animation).length
	)
		
	if Input.is_physical_key_pressed(KEY_Q):
		pinch_progress += (_pl.get_process_delta_time() * _delta) * 50
		if pinch_progress > 0.45:
			_pl.components.get_component_by_name(Player2D.Components.ANIMATION).play_animation(pinch_animation, 1)
			_pl.components.get_component_by_name(Player2D.Components.ANIMATION).seek(.45)
	
	else:
		pinch_progress -= (_pl.get_process_delta_time() * _delta) * 45
		if pinch_progress <= 0:
			_pl.force_change_state("idle")
			_pl.components.get_component_by_name(Player2D.Components.ACTION).cancel_action(_pl)

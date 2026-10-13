extends PLAction

@export var pinch_animation: StringName = &"action/pinch"
@export var deequip_effect: bool = true
@export_file("*.tscn") var return_location: String = "res://src/levels/_real/apartment/level.tscn"

func _perform(_pl: Player) -> void:
	if DreamManager.global_dream_state != DreamManager.state.DREAM:
		return
	
	if load(SceneManager.curr_scene_resource.resource_path) == load(return_location):
		
		AudioService.play_sound(Player.ERR_SOUNDS.pick_random()) 
		return

	EventManager.invoke_event("CUTSCENE_START_REQUEST")
	_pl.vel_input = Vector2.ZERO
	_pl.dir_input = Vector2.ZERO
	_pl.velocity = Vector2.ZERO
	
	if deequip_effect: _pl.deequip_effect()
	_pl.force_change_state("action")
	
	_pl.components.get_component_by_name(Player_YN.Components.ANIMATION).play_animation(pinch_animation, 1)
	await _pl.components.get_component_by_name(Player_YN.Components.ANIMATION).finished
	_pl._freeze()
	
	var seq = SequencerManager.create_sequence("go_to_real_world")
	var wait 				:= EVN_WaitSeconds.new(1)
	
	seq.append(wait, 		"wait")
	
	SequencerManager.invoke(seq)
	await seq.finished
	
	SceneManager.change_scene_to(load(return_location))
	
	

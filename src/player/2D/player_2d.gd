class_name Player2D
extends Actor2D

@export var sound_player: AudioStreamPlayer

var sm: SM
var action: PLAction 

func _ready() -> void:
	super()
	sm = SM.build(PlayerStateRoot.new(null, null, self))
	sm.start()

func _update(_delta: float) -> void:	
	super(_delta)
	sm.update(_delta)
	
func _physics_update(_delta: float) -> void:
	super(_delta)
	sm.phys_update(_delta)
	
func _sb_input(event: InputEvent) -> void:
	if components != null: 	components._input_pass(event)
	
func get_behaviour() -> PLBehaviour: 
	return preload("res://src/player/2D/effects/_none/_behaviour.tres")

func play_sound(_sound: AudioStreamWAV, _vol: float, _pitch: float) -> void:
	if sound_player != null: sound_player.play_sound(_sound, _vol, _pitch)

# -------------------------------------------------------------

class Components:
	const ANIMATION 	:= &"animation_component"
	const ACTION 		:= &"action_component"
	const SPRITE 		:= &"sprite_component"
	const INTERACT 		:= &"interaction_component"
	const FOOTSTEP 		:= &"footstep_component"
	const INPUT 		:= &"input"

class Constants:
	const ANIM_LIB_PATH_NORMAL 		:= "normal"
	const ANIM_LIB_PATH_SPECIAL 	:= "special"
	const ANIM_LIB_PATH_EMOTE 		:= "emote"
	const ANIM_LIB_PATH_ACTION:		= "action"

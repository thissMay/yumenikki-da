class_name Player_YN 
extends Player

# - dependencies.
@export_category("Top-down Exclusive")
@export var can_pinch: bool = true

var sm: SM
var sound_player: AudioStreamPlayer

# - trait components
var action: PLAction 

func _init() -> void:
	sm = SM.build(PlayerStateRoot.new(null, null, self))

func _ready() -> void:
	super()
	sm.start()
	
	Utils.connect_to_signal(
		func(_in):
			vel_input = _in
			dir_input = _in, 	
		self.input_vector)
	
	Utils.connect_to_signal(get_behaviour()._interact, quered_interact)
func _enter() -> void:
	super()

func dependency_components() -> void:	
	sound_player = $sound_player

func _update(_delta: float) -> void:	
	super(_delta)
	sm.update(_delta)
	
func _physics_update(_delta: float) -> void:
	super(_delta)
	sm.phys_update(_delta)
	
func _sb_input(event: InputEvent) -> void:
	if components != null: 	components._input_pass(event)
	sm.input_pass(event)
	
func get_behaviour() -> PLBehaviour: 
	return preload("res://src/player/2D/madotsuki/effects/_none/_behaviour.tres")

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
	const ANIM_LIB_PATH_NORMAL := "normal"
	const ANIM_LIB_PATH_SPECIAL := "special"
	const ANIM_LIB_PATH_EMOTE := "emote"
	const ANIM_LIB_PATH_ACTION:= "action"

class_name Game 
extends Node

const STATE_PRELOAD_CONTENT 	:= "preload_content"
const STATE_PREGAME 			:= "pregame"
const STATE_ACTIVE 				:= "active"
const STATE_PAUSE 				:= "pause"
const STATE_SWITCHING_SCENES 	:= "changing_scenes"

const GAME_VER := "DEMO"

static var is_paused: bool = false
static var root: Window
static var main_tree: SceneTree

# -- 
static var bloom: bool = false

static var global_screen_effect: WorldEnvironment
static var global_components: ComponentReceiver

static var instance: Game

# ---- audio ----
static var aud_music: SoundPlayer
static var aud_amb: SoundPlayer
static var aud_ui: SoundPlayer

# ---- canvas properties ----
static var screen_transition: 		ScreenTransition

# ---- process parents ----
static var pausable_parent: Node
static var always_parent: Node

# ---- UI ----
static var player_hud: PLHUDManager
static var options: IngameSettings

# ---- cinematic ----
static var cinematic_bars: TextureRect
static var cb_tween: Tween

# ---- components
static var game_fsm: SM
static var state_handle: Component

func _setup() -> void:
	self.process_mode = Node.PROCESS_MODE_INHERIT
	

	instance = self
	
	player_hud = PLHUDManager.instance
	
	aud_music = $aud_music
	aud_amb = $aud_amb
	aud_ui = $aud_ui
	
	game_fsm 				= get_node("game_fsm")
	state_handle			= get_node("state_handle")
	
	global_components 		= get_node("global_components")
	global_screen_effect 	= get_node("global_screen_effect")
	
	pausable_parent 		= get_node("pausable")
	always_parent 			= get_node("always")

	cinematic_bars 			= get_node("always/cinematic_bars")
	options 				= get_node("always/pause")
	
	screen_transition 		= get_node("always/transition")

	pausable_parent.process_mode = Node.PROCESS_MODE_PAUSABLE
	always_parent.process_mode = Node.PROCESS_MODE_ALWAYS
	
	cinematic_bars.position.y = -45
	cinematic_bars.size.y = 360
	
	global_screen_effect.environment.glow_enabled = bloom
	
	screen_transition.		fade(ScreenTransition.DEFAULT_GRADIENT, 1, 0)
	
func update(_delta: float) -> void: 
	game_fsm._update(_delta)
	if global_components: global_components._update(_delta)
func physics_update(_delta: float) -> void: 
	game_fsm._physics_update(_delta)
	if global_components: global_components._physics_update(_delta)
func input_pass(event: InputEvent) -> void: 
	game_fsm._input_pass(event)
	
# - game functionality
static func pause_options(_pause: bool = true) -> void:
	if _pause: change_to_state("pause")
	elif !_pause: change_to_state("active")
static func pause(_pause: bool = true) -> void:
	if _pause: Application.pause()
	else: Application.resume()
	
# - UI stuff
static func set_cinematic_bars(_active: bool) -> void: 
	if cb_tween != null: cb_tween.kill()
	cb_tween = cinematic_bars.create_tween()
	cb_tween.set_parallel()
	cb_tween.set_ease(Tween.EASE_OUT)
	cb_tween.set_trans(Tween.TRANS_EXPO)
	
	match _active:
		true:
			cinematic_bars.visible = _active
			cb_tween.tween_property(cinematic_bars, "size:y", 270, 1)
			cb_tween.tween_property(cinematic_bars, "position:y", 0, 1)
		false:
			cb_tween.tween_property(cinematic_bars, "size:y", 360, 1)
			cb_tween.tween_property(cinematic_bars, "position:y", -45, 1)
			await cb_tween.finished
			cinematic_bars.visible = false

# - state based stuff
static func change_to_state(new_state: String) -> void:
	game_fsm.change_to_state(new_state)
static func is_in_state(state: String) -> bool: return game_fsm._is_in_state(state)

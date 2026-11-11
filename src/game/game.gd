class_name Game 
extends Node

# gonna make the game be a control node that way the themes,
# that is applied to game is applied to all. 

# the problem with this it doesn't apply to the ui layer, namely the hud node.
# ill figure the fix for this later.
const STATE_PRELOAD_CONTENT 	:= "preload_content"
const STATE_PREGAME 			:= "pregame"
const STATE_ACTIVE 				:= "active"
const STATE_PAUSE 				:= "pause"
const STATE_SWITCHING_SCENES 	:= "changing_scenes"

var sm: SM
var state_root: State

const GAME_VER := "DEMO"

static var started: bool = false

static var is_editor: bool = false:
	get: return Engine.is_editor_hint()
static var is_paused: bool:
	get: return main_tree.paused

static var root: Window
static var main_tree: SceneTree

# -- 
static var bloom: bool = false
static var global_screen_effect: WorldEnvironment

static var instance: Game

# ---- audio ----
static var aud_music: SoundPlayer
static var aud_amb: SoundPlayer
static var aud_ui: SoundPlayer

# ---- canvas properties ----
static var screen_transition: 		ScreenTransition

# ---- process parents ----
@export var _scene_container: Node
static var scene_container: 
	get: return instance._scene_container
static var always_parent: Node

# ---- UI ----
static var options_menu: IngameSettings
var inventory_menu: Control

# ---- cinematic ----
static var cinematic_bars: TextureRect
static var cb_tween: Tween

func _setup() -> void:
	state_root = GameStateRoot.new(null, null)
	sm = SM.build(state_root)
	
	instance = self
	
	aud_music = $aud_music
	aud_amb = $aud_amb
	aud_ui = $aud_ui
	
	global_screen_effect 	= get_node("global_screen_effect")
	
	always_parent 			= get_node("always")

	inventory_menu 			= get_node("always/ui_parent/inventory_display")
	cinematic_bars 			= get_node("always/ui_parent/cinematic_bars")
	options_menu 			= get_node("always/ui_parent/pause_menu")
	
	screen_transition 		= get_node("always/ui_parent/transition")

	process_mode 					= Node.PROCESS_MODE_ALWAYS
	always_parent.process_mode 		= Node.PROCESS_MODE_ALWAYS
	scene_container.process_mode 	= Node.PROCESS_MODE_PAUSABLE
	
	global_screen_effect.environment.glow_enabled = bloom
	
	sm.start()
	
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_READY:
			main_tree 	= get_tree()
			root 		= get_tree().root
			
		NOTIFICATION_INTERNAL_PROCESS:
			InputManager.		_update(Global.delta)
			SequencerManager.	_update(Global.delta)
			sm.					 update(Global.delta)
			
		NOTIFICATION_INTERNAL_PHYSICS_PROCESS:
			InputManager.		_physics_update(Global.phys_delta)
			SequencerManager.	_physics_update(Global.phys_delta)
			sm.						phys_update(Global.phys_delta)
			
		NOTIFICATION_WM_CLOSE_REQUEST:
			Application.quit()
			
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			Application.pause()
			
func _input(_event: InputEvent) -> void:
	InputManager._input_pass(_event)
	sm.input_pass(_event)
	
func _unhandled_input(_event: InputEvent) -> void:
	InputManager._unhandled_input_pass(_event)
	
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

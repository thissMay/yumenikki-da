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
static var scene_container: Node
static var always_parent: Node

# ---- UI ----
static var player_hud: Control
static var options_menu: IngameSettings
var inventory_menu: Control

# ---- cinematic ----
static var cinematic_bars: TextureRect
static var cb_tween: Tween

# ---- components
static var state_handle: Component


func state_setup() -> void:
	state_root = GameStateRoot.new(null, null)
	sm = SM.build(state_root)
	sm.start()

func _setup() -> void:
	instance = self
	player_hud = PLHUDManager.instance
	
	aud_music = $aud_music
	aud_amb = $aud_amb
	aud_ui = $aud_ui
	
	global_components 		= get_node("global_components")
	global_screen_effect 	= get_node("global_screen_effect")
	
	scene_container 		= get_node("scene_container")
	always_parent 			= get_node("always")

	inventory_menu 			= get_node("always/ui_parent/inventory_display")
	cinematic_bars 			= get_node("always/ui_parent/cinematic_bars")
	options_menu 			= get_node("always/ui_parent/pause_menu")
	
	screen_transition 		= get_node("always/ui_parent/transition")

	scene_container.process_mode = Node.PROCESS_MODE_PAUSABLE
	always_parent.process_mode = Node.PROCESS_MODE_ALWAYS
	
	global_screen_effect.environment.glow_enabled = bloom
	
	state_setup()
	
	
func update(_delta: float) -> void: 
	sm.update(_delta)
	if global_components: global_components._update(_delta)
func physics_update(_delta: float) -> void: 
	sm.phys_update(_delta)
	if global_components: global_components._physics_update(_delta)
func input_pass(_event: InputEvent) -> void: 
	sm.input_pass(_event)
	
	
# - game functionality
	
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

class_name DreamManager
extends Component

enum state {DREAM, NEUTRAL}

static var global_dream_state: state

@export var curr_reality_mode: 	LegacyState
@export var dream_mode: 		LegacyState
@export var neutral_mode: 		LegacyState

const DREAM_LEVEL_DIR := "res://src/levels/_dream"
const REAL_LEVEL_DIR := "res://src/levels/_real"

@onready var scene_changed_listener := EventListener.new(self, "SCENE_PUSHED")
@onready var reality_override_listener := EventListener.new(self, "OVERRIDE_TO_DREAM_STATE", "OVERRIDE_TO_NEUTRAL_STATE")

func _setup() -> void:
	scene_changed_listener.do_on_notify(
		determine_world_state_by_path, "SCENE_PUSHED")
	reality_override_listener.do_on_notify(func(): enforce_reality_state(state.DREAM), "OVERRIDE_TO_DREAM_STATE")
	reality_override_listener.do_on_notify(func(): enforce_reality_state(state.NEUTRAL), "OVERRIDE_TO_NEUTRAL_STATE")

func _enter() -> void:
	if curr_reality_mode == null: return
	curr_reality_mode._state_enter()
func _exit() -> void: 
	if curr_reality_mode == null: return
	curr_reality_mode._state_exit()
	
func _input_pass(event: InputEvent) -> void: 
	if curr_reality_mode != null: curr_reality_mode.state_input(event)

func determine_world_state_by_path() -> void: 
	if SceneManager.curr_scene_resource == null: return
	
	var scene: String = SceneManager.curr_scene_resource.resource_path
	var scene_dir_path = scene.split("/")
	
	if "_dream" in scene_dir_path: 	enforce_reality_state(state.DREAM)
	else:							enforce_reality_state(state.NEUTRAL)

func enforce_reality_state(_state: state) -> void:
	if curr_reality_mode != null:
		curr_reality_mode.state_exit()
	
	global_dream_state = _state
	
	match _state:
		state.DREAM:
			EventManager.invoke_event("REALITY_DREAM")
			curr_reality_mode = dream_mode
		state.NEUTRAL:
			EventManager.invoke_event("REALITY_NEITHER")
			curr_reality_mode = neutral_mode

	curr_reality_mode.state_enter()

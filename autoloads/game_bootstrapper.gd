extends Control

var finished_preloading_content: bool = false
var is_editor: bool = false

# - scene paths
const INITIAL_SCENE 		:= "res://src/scenes/initial_scene.tscn" 		# - 0
const PRELOAD_SHADERS_SCENE := "res://src/scenes/debug_preload.tscn" 		# - 1
const PREMENU_SCENE			:= "res://src/scenes/pre_menu.tscn"				# - 2
const MENU_SCENE 			:= "res://src/levels/_neutral/menu/menu.tscn"	# - 3

const PREGAME_SCENES 		:= [INITIAL_SCENE, MENU_SCENE, PREMENU_SCENE]

# - signals

# The main game holds a child node that acts as the scene currently active.
# Upon scene change, remove the current child and queue load for the requested one.

func singleton_setup() -> void: 
	if Game.instance == null:
		Game.instance			= preload("res://src/main/game.tscn").instantiate()
		Game.instance.name 		= "game"
		self.add_child(Game.instance)
		
	else:
		Game.instance.reparent(self)

func _enter_tree() -> void:
	Game.main_tree 	= get_tree()
	Game.root 		= get_tree().root
	
	EventManager.		_setup()
	SceneManager.		_setup()
	Application.		_setup()
	AudioBusManager.	_setup()
	ConfigManager.		_setup()
	Directory.			_setup()
	Optimization.		_setup()
	Save.				_setup() 
	InputManager.		_setup()
	SequencerManager.	_setup()
	
func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	singleton_setup()
	
	PhysicsServer2D.set_active(false)
	ProjectSettings.set_setting("application/config/version", Game.GAME_VER)
	
	set_process			(false)
	set_physics_process	(false)
	set_process_input	(false)
	
	Game.instance.					_setup()
	Game.instance.global_components.	_setup()
	Game.instance.state_handle.		_setup()
	
	# - post-initializtion.

	set_process			(true)
	set_physics_process	(true)
	set_process_input	(true)
	
	Global.game_ready.emit()
	PhysicsServer2D.set_active(true)
	
	await Game.main_tree.process_frame
	initialize()
	
	
func _process(delta: float) -> void: 
	InputManager.		_update(delta)
	SequencerManager.	_update(delta)
	SceneManager.		_update(delta)
	Game.instance.				 update(delta)
	
func _physics_process(delta: float) -> void:
	InputManager.		_physics_update(delta)
	SequencerManager.	_physics_update(delta)
	SceneManager.		_physics_update(delta)
	Game.instance.				 physics_update(delta)
func _input(_event: InputEvent) -> void:
	Game.instance.input_pass(_event)
	InputManager._input_pass(_event)
func _unhandled_input(_event: InputEvent) -> void:
	InputManager._unhandled_input_pass(_event)

func get_mouse_position_within_vp() -> Vector2:
	return clamp(Application.main_viewport.get_mouse_position(), Vector2.ZERO, Application.get_viewport_dimens())
func get_mouse_position() -> Vector2:
	return Application.main_viewport.get_mouse_position() - (Application.get_viewport_dimens() / 2)
# ---- rendering server control ----

	

# --- game's initial state (and is editor determination)
func initialize() -> void: 
	var initial_scene: PackedScene = SceneManager.curr_scene_resource
	if initial_scene == null: return
	
	match initial_scene.resource_path:
		INITIAL_SCENE: 
			is_editor = false
			SceneManager.change_scene_to(load(PRELOAD_SHADERS_SCENE), false, false)
		_:	
			is_editor = true

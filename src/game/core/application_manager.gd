class_name Application
extends GameDependency
	
static func _setup() -> void:
	main_window 	= Game.main_tree.root.get_window()
	main_viewport 	= Game.main_tree.root.get_viewport()
	
	main_window.close_requested.connect(on_quit)
	
	window_setup()
	viewport_setup()
	render_server_setup()
	
static var viewport_width: int
static var viewport_length: int
static var viewport_content_scale: float
static var main_window: Window
static var main_viewport: Viewport
static var viewport_size

static func quit(): 
	on_quit()
	await Game.screen_transition.fade(ScreenTransition.DEFAULT_GRADIENT, 0, 1)
	
	if Game.instance != null:
		Game.instance.process_mode = Node.PROCESS_MODE_DISABLED
	Game.main_tree.quit.call_deferred()
static func pause(): 
	Game.is_paused = true
	Game.main_tree.paused = true
static func resume(): 
	Game.is_paused = false
	Game.main_tree.paused = false

static func on_quit() -> void:
	Optimization.set_max_fps(30)
	Save.		save_data()

static func get_viewport_width() -> int: return ProjectSettings.get("display/window/size/viewport_width")
static func get_viewport_height() -> int: return ProjectSettings.get("display/window/size/viewport_height")		
static func get_viewport_dimens(_account_content_scale: bool = false) -> Vector2: 
	if _account_content_scale: return Vector2(viewport_width, viewport_length) / viewport_content_scale
	else: return Vector2(viewport_width, viewport_length)
static func viewport_setup() -> void:
	
	viewport_width = get_viewport_width()
	viewport_length = get_viewport_height()
	viewport_content_scale = ProjectSettings.get("display/window/stretch/scale")

static func window_setup() -> void:
	Engine.max_fps = 60
	ProjectSettings.set_setting("rendering/textures/canvas_textures/default_texture_repeat", CanvasItem.TEXTURE_REPEAT_MIRROR)
	
	main_window.size = Vector2(1440, 810)
	
	main_window.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_FRACTIONAL
	main_window.position = DisplayServer.screen_get_size(DisplayServer.get_primary_screen()) / 2 - main_window.size / 2 
	main_window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	
	main_window.focus_exited.connect(func(): 
		pause())
	main_window.focus_entered.connect(func(): 
		resume())
	
static func change_window_mode(new_mode: Window.Mode) -> void: main_window.mode = new_mode
static func set_window_borderless(_brd: bool = true) -> void: main_window.borderless = _brd

static func render_server_setup() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)

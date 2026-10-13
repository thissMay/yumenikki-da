class_name Application
extends GameDependency
	
static var viewport_width: int:
	get: return ProjectSettings.get("display/window/size/viewport_width")

static var viewport_length: int:
	get: return ProjectSettings.get("display/window/size/viewport_height")	

static var viewport_size: Vector2:
	get: return Vector2(viewport_width, viewport_length)

static var main_window: Window
static var main_viewport: Viewport
	
static func _setup() -> void:
	main_window 	= Game.main_tree.root.get_window()
	main_viewport 	= Game.main_tree.root.get_viewport()
	
	window_setup()
	render_server_setup()

static func quit(): 
	Game.main_tree.quit.call_deferred()
static func pause(): 
	Game.is_paused = true
	Game.main_tree.paused = true
static func resume(): 
	Game.is_paused = false
	Game.main_tree.paused = false

static func window_setup() -> void:
	Engine.max_fps = 60
	ProjectSettings.set_setting("rendering/textures/canvas_textures/default_texture_repeat", CanvasItem.TEXTURE_REPEAT_MIRROR)
	
	main_window.size = viewport_size * 2
	
	main_window.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_FRACTIONAL
	main_window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	main_window.position = DisplayServer.screen_get_size(DisplayServer.get_primary_screen()) / 2 - main_window.size / 2 
	
	main_window.focus_exited.connect(func(): pause())
	main_window.focus_entered.connect(func(): resume())
	
static func change_window_mode(new_mode: Window.Mode) -> void: main_window.mode = new_mode
static func set_window_borderless(_brd: bool = true) -> void: main_window.borderless = _brd

static func render_server_setup() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)

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
	main_window 	= Game.root.get_window()
	main_viewport 	= Game.root.get_viewport()
	window_setup()

static func quit(): 
	Game.main_tree.quit()
static func pause(): 
	Global.paused.emit()
static func resume(): 
	Global.resumed.emit()

static func window_setup() -> void:
	Engine.max_fps = 60
	
	RenderingServer.set_default_clear_color(Color.BLACK)
	RenderingServer.viewport_set_default_canvas_item_texture_repeat(main_window.get_viewport_rid(), RenderingServer.CANVAS_ITEM_TEXTURE_REPEAT_MIRROR)
	RenderingServer.viewport_set_default_canvas_item_texture_filter(main_window.get_viewport_rid(), RenderingServer.CANVAS_ITEM_TEXTURE_FILTER_NEAREST)	
	
	main_window.size = viewport_size * 2
	main_window.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_FRACTIONAL
	main_window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	main_window.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN
	
static func change_window_mode(new_mode: Window.Mode) -> void: main_window.mode = new_mode
static func set_window_borderless(_brd: bool = true) -> void: main_window.borderless = _brd

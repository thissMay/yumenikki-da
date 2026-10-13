class_name Optimization
extends GameDependency

static func _setup() -> void: 
	RenderingServer.viewport_set_default_canvas_item_texture_repeat(
		Application.main_window.get_viewport_rid(), RenderingServer.CANVAS_ITEM_TEXTURE_REPEAT_MIRROR)
	RenderingServer.viewport_set_default_canvas_item_texture_filter(
		Application.main_window.get_viewport_rid(), RenderingServer.CANVAS_ITEM_TEXTURE_FILTER_NEAREST)	
	
	Application.main_window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS

static var footstep_instances: int = 0

const FOOTSTEP_MAX_INSTANCES: int = 24
const PARTICLES_MAX_INSTANCES: int = 128

#static func setup_overridden_project_settings() -> void:
	#if override_godot_default_settings:
		#RenderingServer.viewport_set_default_canvas_item_texture_repeat(
			#Application.main_window.get_viewport_rid(), RenderingServer.CANVAS_ITEM_TEXTURE_REPEAT_MIRROR)
		#RenderingServer.viewport_set_default_canvas_item_texture_filter(
			#Application.main_window.get_viewport_rid(), RenderingServer.CANVAS_ITEM_TEXTURE_FILTER_NEAREST)	
		#
		#Application.main_window.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
		#Application.main_window.canvas_item_default_texture_repeat = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_MIRROR
		#Application.main_window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS

static func set_max_fps(_max_fps: int) -> void:
	Engine.max_fps = _max_fps

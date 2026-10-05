extends UIStackNode

@export var borderless: CheckBox
@export var full_screen: CheckBox
@export var cam_reduction: CheckBox
@export var bloom: CheckBox

func _ready() -> void:
	super()
	
	borderless.button_pressed = 	ConfigManager.get_setting_data("graphics", "borderless", false)
	full_screen.button_pressed = 	ConfigManager.get_setting_data("graphics", "fullscreen", false)
	cam_reduction.button_pressed = 	ConfigManager.get_setting_data("graphics", "motion_reduce", false)
	bloom.button_pressed = 			ConfigManager.get_setting_data("graphics", "bloom", false)
	
	borderless.toggled.connect(		func(_truth: bool): 
		Application.set_window_borderless(_truth))
	full_screen.toggled.connect(	func(_truth: bool): 
		Application.change_window_mode(Window.MODE_FULLSCREEN) if _truth else Application.change_window_mode(Window.MODE_WINDOWED))
	cam_reduction.toggled.connect(	func(_truth: bool): 
		CameraHolder.motion_reduction = _truth)
	bloom.toggled.connect(			func(_truth: bool): 
		Game.global_screen_effect.environment.glow_enabled = _truth
		Game.bloom = _truth)
		

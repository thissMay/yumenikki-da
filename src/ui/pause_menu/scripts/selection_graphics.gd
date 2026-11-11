extends UIStackNode

@export var borderless: CheckBox
@export var full_screen: CheckBox
@export var cam_reduction: CheckBox
@export var bloom: CheckBox

func _ready() -> void:
	super()
	
	borderless.toggled.connect(		func(_truth: bool): 
		Application.set_window_borderless(_truth))
	full_screen.toggled.connect(	func(_truth: bool): 
		Application.change_window_mode(Window.MODE_FULLSCREEN) if _truth else Application.change_window_mode(Window.MODE_WINDOWED))
	bloom.toggled.connect(			func(_truth: bool): 
		Game.global_screen_effect.environment.glow_enabled = _truth
		Game.bloom = _truth)
		

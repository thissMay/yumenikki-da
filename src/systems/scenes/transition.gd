class_name ScreenTransition
extends TextureRect

const DEFAULT_SHADER: Shader 		= preload("res://src/shaders/transition/tr_fade.gdshader")
const DEFAULT_GRADIENT: Gradient 	= preload("res://src/main/default_transition_gradient.tres")

var gradient: Gradient

var fade_in_shader: 	ShaderMaterial
var fade_out_shader: 	ShaderMaterial
var default_shader: 	ShaderMaterial

var fade_tween: Tween
var fade_progress: float = 0:
	set = set_fade_progress

# - transition animation properties.
var transition_type: 	Tween.TransitionType = Tween.TRANS_LINEAR
var ease_type: 			Tween.EaseType = Tween.EASE_OUT
var duration: float = 1

func _ready() -> void:
	
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	self.z_index = 99
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	
	fade_in_shader = ShaderMaterial.new()
	fade_out_shader = ShaderMaterial.new()
	default_shader = ShaderMaterial.new()
	
	default_shader.shader = DEFAULT_SHADER
	fade_in_shader = default_shader
	fade_out_shader = default_shader
	
	self.set_size.call_deferred(Vector2(Application.viewport_size))
	self.material = default_shader
	self.visible = false

func fade(
	_gradient: Gradient = DEFAULT_GRADIENT,
	_start_progress: float = 1,
	_end_progress: float = 0) -> void:
		self.visible = true 
		self.gradient = _gradient
		
		if fade_tween != null: fade_tween.kill()
		fade_tween = self.create_tween()
		
		self.material.set_shader_parameter("progress", _start_progress)
		
		fade_tween.tween_method(
			set_fade_progress,
			_start_progress, 
			_end_progress, 
			duration).set_trans(transition_type).set_ease(ease_type)
			
		await fade_tween.finished
			
func set_fade_progress(_progress: float):
	fade_progress = _progress
	self.material.set_shader_parameter("progress", fade_progress)
	self.modulate = gradient.sample(fade_progress)
	
func set_transition(
	_duration: float = 1,
	_custom_shader: ShaderMaterial = null,
	_transition: Tween.TransitionType = Tween.TRANS_LINEAR,
	_ease: Tween.EaseType = Tween.EASE_OUT) -> void: 
		self.transition_type 	= _transition
		self.ease_type 			= _ease
		self.duration				= _duration
		
		if _custom_shader == null: self.material = default_shader
		else: self.material = _custom_shader
func set_fade_out_shader(_shader: ShaderMaterial) -> void: 
	if _shader.shader == null: 
		fade_out_shader.shader = DEFAULT_SHADER
		self.material = fade_out_shader
		return
		
	fade_out_shader = _shader
	self.material = _shader
func set_fade_in_shader(_shader: ShaderMaterial) -> void:
	if _shader.shader == null: 
		fade_in_shader.shader = DEFAULT_SHADER
		self.material = fade_in_shader
		return
		
	fade_in_shader = _shader
	self.material = _shader

func reset_fade_shaders() -> void:
	self.material = default_shader

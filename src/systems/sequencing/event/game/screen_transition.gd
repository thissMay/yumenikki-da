@tool

class_name EVN_ScreenTransition
extends Event

@export_category("Screen Fade Properties.")
@export var fade_shader: ShaderMaterial

@export_group("Fade speed and colour")
@export var duration: float = 1
@export var a: float = 0
@export var b: float = 1
@export var hide_if_alpha_zero: bool = true
@export var gradient: Gradient = preload("res://src/main/default_transition_gradient.tres").duplicate()

@export_group("Tween properties")
@export var transition: Tween.TransitionType = Tween.TRANS_LINEAR
@export var ease_type: Tween.EaseType = Tween.EASE_OUT

var force_quit_timer: SceneTreeTimer

func _init( 
	_a: float = 0, 
	_b: float = 1, 
	_duration: float = 1, 
	_trans: Tween.TransitionType = Tween.TRANS_LINEAR, 
	_ease: Tween.EaseType = Tween.EASE_OUT) -> void:
		a 			= _a
		b 			= _b
		duration 	= _duration
		transition 	= _trans
		ease_type 		= _ease

func _execute() -> void:
	Game.instance.screen_transition.set_transition(
		duration,
		fade_shader,
		transition)

	await Game.instance.screen_transition.fade(gradient, a, b,)

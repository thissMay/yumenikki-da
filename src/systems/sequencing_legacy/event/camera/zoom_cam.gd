@tool

class_name EVN_ZoomCamera 
extends Event

@export var zoom: float = 1
@export var ease_type: Tween.EaseType = Tween.EASE_OUT
@export var trans: Tween.TransitionType = Tween.TRANS_EXPO
@export var duration: float = 1		

func _init(
	_zoom: float, 
	_ease: Tween.EaseType 			= Tween.EASE_OUT, 
	_trans: Tween.TransitionType 	= Tween.TRANS_EXPO, 
	_duration: float 				= 1) -> void:
		
		zoom 		= _zoom
		ease_type 	= _ease
		trans 		= _trans
		duration 	= _duration

func _execute() -> void:
	await CCamera2D.instance.lerp_zoom(zoom, ease_type, trans, duration)

func _validate() -> bool: 
	return CCamera2D.instance != null

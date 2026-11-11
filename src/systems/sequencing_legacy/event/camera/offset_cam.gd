class_name EVN_OffsetCam 
extends Event

@export var offset: Vector2
@export var ease: Tween.EaseType = Tween.EASE_OUT
@export var trans: Tween.TransitionType = Tween.TRANS_EXPO
@export var duration: float = 1

func _init(
	_offset := Vector2.ZERO, 
	_ease := Tween.EASE_OUT, 
	_trans := Tween.TRANS_LINEAR,
	_duration: float = 1) -> void:
		offset 		= _offset
		ease 		= _ease
		trans 		= _trans
		duration 	= _duration

func _execute() -> void:
	await CCamera2D.instance.lerp_offset(offset, ease, trans, duration)
	
func _validate() -> bool: 
	return CCamera2D.instance != null

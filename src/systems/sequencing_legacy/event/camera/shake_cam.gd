class_name ShakeCam
extends Event

@export var magnitude: float = 1
@export var speed: float = 1
@export var dur: float = 1

func _execute() -> void:
	CCamera2D.instance.shake(magnitude, speed, dur)

func _validate() -> bool: 
	return CCamera2D.instance != null

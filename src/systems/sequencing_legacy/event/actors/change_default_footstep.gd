class_name EVN_ChangeDefaultFootstep
extends Event

@export var footstep: Array[AudioStream]

func _execute() -> void:
	FootstepComponent.global_footstep = footstep

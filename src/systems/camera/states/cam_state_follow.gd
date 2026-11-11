class_name CamStateFollow
extends CamState

func phys_update(_delta: float) -> void:
	if cam.curr_target != null:
		cam.global_position = cam.curr_target.global_position

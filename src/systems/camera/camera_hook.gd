class_name CCameraHook
extends Node2D

@export var priority: int = 0
const STRING_HOOK_ID: String = "cam_hook"

func _notification(what: int) -> void:
	if what == NOTIFICATION_POSTINITIALIZE:
		add_to_group(STRING_HOOK_ID)

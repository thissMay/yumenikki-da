class_name EVN_WaitSeconds
extends Event

var timer: SceneTreeTimer
@export var seconds: float = 1

func _init(_seconds: float = 1) -> void: seconds = _seconds
func _execute() -> void:
	timer = Game.main_tree.create_timer(seconds, true, false, true)
	await timer.timeout

func _end() -> void:
	timer = null

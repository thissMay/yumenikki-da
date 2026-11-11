class_name EVN_PlayAnimation
extends Event

@export var animator: AnimationPlayer
@export var animation_path: StringName
@export var animation_speed: float = 1
@export var animation_backwards: bool = false

func _execute() -> void:
	animator.play(
		animation_path, -1,
		animation_speed, animation_backwards)
	await animator.animation_finished

func _validate() -> bool:
	if !animator.has_animation(animation_path): 
		printerr("EVENT - PLAY ANIMATION :: Animation does not have animation!")
		return false
	return true

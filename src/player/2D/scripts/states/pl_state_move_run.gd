class_name PlayerStateMoveRun
extends Actor2DState

func on_enter() -> void:
	actor.speed_multiplier = actor.values.sprint_multi
	actor.components.get_component_by_name("animation_manager").play_animation(
		str(Player2D.Constants.ANIM_LIB_PATH_NORMAL, '/', "run"))

func get_transition() -> State:
	if !PlayerInstance.is_running: return (parent as PlayerStateMoving).walk
	return null

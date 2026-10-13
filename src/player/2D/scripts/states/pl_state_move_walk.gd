class_name PlayerStateMoveWalk
extends Actor2DState

func on_enter() -> void:
	actor.components.get_component_by_name("animation_manager").play_animation(
		str(Player_YN.Constants.ANIM_LIB_PATH_NORMAL, '/', "walk"))

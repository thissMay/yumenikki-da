class_name PlayerStateIdle
extends Actor2DState

func on_enter() -> void:
	actor.velocity = Vector2.ZERO
	actor.position = actor.position.round()

	actor.components.get_component_by_name("animation_manager").play_animation(
		str(Player2D.Constants.ANIM_LIB_PATH_NORMAL, '/', "idle"))

func get_transition() -> State:
	if (actor.desired_speed > 0):
		return (parent as PlayerStateRoot).move
	return null

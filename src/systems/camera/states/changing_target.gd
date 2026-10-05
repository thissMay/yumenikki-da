extends LegacyState

var change_tween: Tween
var target_position: Vector2
@export var switch_timer: Timer

func _state_enter() -> void: 
	switch_timer.one_shot = true
	switch_timer.autostart = false
	switch_timer.wait_time = context.switch_duration
	switch_timer.timeout.connect(func(): request_transition_to("following"), ConnectFlags.CONNECT_ONE_SHOT) 
	switch_timer.start()

func _state_physics_update(_delta: float) -> void: 
	target_position = context.curr_target.global_position
	context.global_position = (
		Tween.interpolate_value(
			context.global_position, 
			target_position - context.global_position,
			_delta,
			context.switch_duration,
			Tween.TRANS_EXPO, 
			Tween.EASE_OUT)
			)
	
	if (Vector2(target_position - context.global_position.round()).length()) <= 1:
		request_transition_to("following") 

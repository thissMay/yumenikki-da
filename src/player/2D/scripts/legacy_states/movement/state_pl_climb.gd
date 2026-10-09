extends SBState

var progress: float
var heading: float

func _state_enter() -> void: 
	actor.animation_manager.anim_state.start("walk")
func _state_exit() -> void:
	actor.animation_manager.anim_state.stop()
	
func _state_update(_delta: float, ) -> void:
	
	actor.animation_manager.update(actor, _delta)
	actor.animation_manager.anim_tree.set("parameters/tree/time_scale/scale", actor.speed / actor.max_speed)
	
func _state_physics_update(_delta: float, ) -> void:
	actor.get_behaviour()._climb(actor)

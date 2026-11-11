class_name PLAction
extends Resource

signal finished

# -- virtuals.
func _perform		(_pl: Player2D) -> void: pass
func _cancel		(_pl: Player2D) -> void: pass
func _force_cancel	(_pl: Player2D) -> void: pass

# - process, phys process and input. 
func _action_input			(_pl: Player2D, _input: InputEvent) -> void: pass
func _action_update			(_pl: Player2D, _delta: float) -> void: pass
func _action_physics_update	(_pl: Player2D, _delta: float) -> void: pass

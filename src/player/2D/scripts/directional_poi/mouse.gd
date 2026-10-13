class_name strat_dir_mouse
extends Strategy

var actual_mouse_pos: Vector2
var registered_vector: Vector2

func _physics_update(_delta: float, _context: Variant = null) -> void: 
	#actual_mouse_pos = Vector2(
			#Game.get_mouse_position() / (Game.Application.get_viewport_dimens()) * 2
			#).normalized()
#			
	registered_vector = actual_mouse_pos.round()
	
	if PlayerInstance.instance != null:
		_context.position = registered_vector

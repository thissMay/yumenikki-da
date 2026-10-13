class_name strat_dir_input
extends Strategy

func _physics_update(_delta: float, _context: Variant = null) -> void: 
	if PlayerInstance.instance != null:
		_context.position = (PlayerInstance.instance.dir_input)

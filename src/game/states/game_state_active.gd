extends State

func on_update(_delta: float) -> void:
	for s in Utils.get_group_arr("actors"):
		if s != null:
			if s.can_process(): s._update(_delta)
			
func on_phys_update(_delta: float) -> void:
	for s in Utils.get_group_arr("actors"):
		if s != null:
			if s.can_process(): s._physics_update(_delta)

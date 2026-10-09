extends State

func on_phys_update() -> void:
	actor.handle_heading()
	actor.handle_velocity()

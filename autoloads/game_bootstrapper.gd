extends Control

# - signals

# The main game holds a child node that acts as the scene currently active.
# Upon scene change, remove the current child and queue load for the requested one.

func singleton_setup() -> void: 
	if Game.instance == null:
		Game.instance			= preload("res://src/main/game.tscn").instantiate()
		Game.instance.name 		= "game"
		self.add_child(Game.instance)
		
	else:
		Game.instance.reparent(self)

func _notification(what: int) -> void:
	if what == NOTIFICATION_POST_ENTER_TREE:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		singleton_setup()
		
		Game.instance.		_setup()
		PlayerInstance.		_setup()
		Application.		_setup()
		EventManager.		_setup()
		SceneManager.		_setup()
		AudioBusManager.	_setup()
		SaveManager.		_setup() 
		InputManager.		_setup()
		SequencerManager.	_setup()
		
		PhysicsServer2D.set_active(false)
		
		set_process			(false)
		set_physics_process	(false)
		set_process_input	(false)
		
		# - post-initializtion.

		await Game.main_tree.process_frame
		
		set_process			(true)
		set_physics_process	(true)
		set_process_input	(true)
		
		PhysicsServer2D.set_active(true)
		
		process_mode = Node.PROCESS_MODE_DISABLED

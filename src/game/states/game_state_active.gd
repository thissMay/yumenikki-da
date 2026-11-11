class_name GameStateActive
extends State

func _init(sm: SM, parent: State):
	super(sm, parent)
	
func handle_pause() -> void:
	sm.change_state(self, (parent as GameStateRoot).state_pause)

func on_exit() -> void:
	Global.paused.disconnect(handle_pause)

func on_enter() -> void:
	Global.paused.connect(handle_pause)
	
	#Game.player_hud.visible 				= true
	Game.options_menu.visible 				= false
	Game.instance.inventory_menu.visible 	= false
	
	Game.set_cinematic_bars(false)

func on_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed(InputConstants.USR_PAUSE): 
		if (!Game.is_paused): 	sm.change_state(self, (parent as GameStateRoot).state_pause)
		else: 					sm.change_state(self, self)
		
	if Input.is_action_just_pressed(InputConstants.USR_PL_HUD_TOGGLE): pass
		#Game.player_hud.visible = !Game.player_hud.visible

func on_update(_delta: float) -> void: 		PlayerInstance._update(_delta)
func on_phys_update(_delta: float) -> void: PlayerInstance._physics_update(_delta)

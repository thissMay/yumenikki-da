class_name GameStatePause
extends State

func _init(sm: SM, parent: State):
	super(sm, parent)

func handle_resume() -> void:
	sm.change_state(self, (parent as GameStateRoot).state_active)
	


func on_enter() -> void:
	Global.resumed.connect(handle_resume)
	
	Application.main_window.grab_focus()
	
	AudioBusManager.adjust_bus_effect(AudioBusManager.BUS_MUSIC, 1, "cutoff_hz", 300)

	Game.main_tree.paused = true
	Game.options_menu.visible = true
	#Game.player_hud.visible = false
	Game.set_cinematic_bars(true)
	
func on_exit() -> void:
	Global.resumed.disconnect(handle_resume)
	
	Application.main_window.gui_release_focus()
	
	AudioBusManager.adjust_bus_effect(AudioBusManager.BUS_MUSIC, 1, "cutoff_hz", 16000)
	
	Game.main_tree.paused = false
	Game.options_menu.visible = false

func on_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed(InputConstants.USR_PAUSE): 
		sm.change_state(self, (parent as GameStateRoot).state_active)

class_name GameStatePause
extends State

func on_enter() -> void:
	AudioBusManager.adjust_bus_effect(AudioBusManager.BUS_MUSIC, 1, "cutoff_hz", 300)
	
	Game.set_cinematic_bars(true)
	Game.player_hud.indicators.visible = false
	Game.options_menu.visible = true
	Game.player_hud.visible = false

	Application.pause()
	Application.main_window.grab_focus()
	
func on_exit() -> void:
	AudioBusManager.adjust_bus_effect(AudioBusManager.BUS_MUSIC, 1, "cutoff_hz", 16000)

	Game.options_menu.visible = false
	Game.player_hud.visible = true
	
	Game.set_cinematic_bars(false)
	Application.resume()
	Application.main_window.gui_release_focus()

func on_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_esc_menu"): 
		print("ass")
		sm.change_state(self, (parent as GameStateRoot).state_active)

extends State

func on_enter() -> void:
	AudioBusManager.adjust_bus_effect(AudioBusManager.BUS_MUSIC, 1, "cutoff_hz", 300)
	
	Game.set_cinematic_bars(true)
	Game.player_hud.indicators.visible = false
	Game.options.visible = true
	Game.player_hud.visible = false

	Application.pause()
	Application.main_window.grab_focus()
	
func on_exit() -> void:
	AudioBusManager.adjust_bus_effect(AudioBusManager.BUS_MUSIC, 1, "cutoff_hz", 16000)

	Game.options.visible = false
	Game.player_hud.visible = true
	
	Game.set_cinematic_bars(false)
	Application.resume()
	Application.main_window.gui_release_focus()

extends LegacyState

@export var pause_menu: Control
@export var hud: Control

func _state_enter() -> void: 
	AudioBusManager.adjust_bus_effect(AudioBusManager.BUS_MUSIC, 1, "cutoff_hz", 300)
	
	Game.set_cinematic_bars(true)
	Game.player_hud.indicators.visible = false
	Game.options.visible = true
	pause_menu	.visible = true
	hud			.visible = false

	Application.pause()
	Application.main_window.grab_focus()

func _state_exit() -> void: 
	AudioBusManager.adjust_bus_effect(AudioBusManager.BUS_MUSIC, 1, "cutoff_hz", 16000)

	Game.options.visible = false
	pause_menu	.visible = false
	hud			.visible = true
	
	Game.set_cinematic_bars(false)
	Application.resume()
	Application.main_window.gui_release_focus()

func _state_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_esc_menu"):
		Game.pause_options(false)

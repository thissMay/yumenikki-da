extends Node

var hud_fade: EventListener
var game_save: EventListener

@export var hud: PLHUDManager
@export var icon: TextureRect
@export var icon_timer: Timer

func _setup() -> void:
	hud_fade = EventListener.new(self, "SCENE_CHANGE_REQUEST", "SCENE_CHANGE_SUCCESS")
	hud_fade.do_on_notify(func(): hud.show_ui(hud, false), "SCENE_CHANGE_REQUEST")
	hud_fade.do_on_notify(func(): hud.show_ui(hud, true), "SCENE_CHANGE_SUCCESS")
	
	game_save = EventListener.new(self, "GAME_SAVE", "CONFIG_SAVE")
	game_save.do_on_notify(
		func(): 
			icon.texture = preload("res://src/images/config_save.png")
			hud.show_ui(icon, true)
			icon_timer.wait_time = 1
			icon_timer.start()
			await icon_timer.timeout
			hud.show_ui(icon, false),
		"CONFIG_SAVE"
			)	
	game_save.do_on_notify(
		func(): 
			icon.texture = preload("res://src/images/save.png")
			hud.show_ui(icon, true)
			icon_timer.wait_time = 1
			icon_timer.start()
			await icon_timer.timeout
			hud.show_ui(icon, false),
		"GAME_SAVE"
			)
	

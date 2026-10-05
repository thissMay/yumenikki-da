class_name ConfigManager
extends GameDependency

static func _setup() -> void:
	instantiate_config()
	load_settings_data()

static var config_data := ConfigFile.new()

static func instantiate_config() -> void:
	if get_setting_data("misc", "instantiated", true): return
	save_settings_data()

static func save_settings_data() -> void: 
	EventManager.invoke_event("GAME_CONFIG_SAVE")
	
	config_data.set_value("audio", "music", 	db_to_linear(AudioBusManager.get_bus_volume("Music")))
	config_data.set_value("audio", "ambience", 	db_to_linear(AudioBusManager.get_bus_volume("Ambience")))
	config_data.set_value("audio", "se", 		db_to_linear(AudioBusManager.get_bus_volume("Effects")))
	
	config_data.set_value("graphics", "borderless", 	Application.main_window.borderless)
	config_data.set_value("graphics", "fullscreen", 	Application.main_window.mode == Window.MODE_FULLSCREEN)
	config_data.set_value("graphics", "motion_reduce", 	CameraHolder.motion_reduction)
	config_data.set_value("graphics", "bloom", 			Game.bloom)
	
	#config_data.set_value("controls", "bind", InputManager.keybind)
	
	config_data.save("user://settings.cfg")
static func load_settings_data() -> void: 
	var s = config_data.load("user://settings.cfg")
	if s != OK: return
	
	AudioBusManager.adjust_bus_volume("Music", config_data.get_value("audio", 	"music"))
	AudioBusManager.adjust_bus_volume("Ambience", config_data.get_value("audio", 	"ambience"))
	AudioBusManager.adjust_bus_volume("Effects", config_data.get_value("audio", 	"se"))
	
	Application.main_window.borderless = config_data.get_value("graphics", "borderless")
	Application.main_window.mode = Window.MODE_FULLSCREEN if config_data.get_value("graphics", "fullscreen") else Window.MODE_WINDOWED
	CameraHolder.motion_reduction = config_data.get_value("graphics", "motion_reduce")
	Game.bloom = config_data.get_value("graphics", "bloom")
	
static func get_setting_data(_section: String, _setting: String, _default: Variant = 0) -> Variant:
	var s = config_data.load("user://settings.cfg")
	if s != OK: return
	
	if config_data.has_section(_section) and config_data.has_section_key(_section, _setting):
		return config_data.get_value(_section, _setting)
	return _default

extends UIStackNode

@export var music_slider: HSlider
@export var amb_slider: HSlider
@export var sfx_slider: HSlider

func _ready() -> void:
	super()
	
	music_slider.value 	= ConfigManager.get_setting_data("audio", "music")
	amb_slider.value 	= ConfigManager.get_setting_data("audio", "ambience")
	sfx_slider.value 	= ConfigManager.get_setting_data("audio", "se")
	
	music_slider.value_changed.connect(func(_val: float): AudioBusManager.adjust_bus_volume("Music", clamp(_val, 0, 1)))
	amb_slider.value_changed.connect(func(_val: float): AudioBusManager.adjust_bus_volume("Ambience", clamp(_val, 0, 1)))
	sfx_slider.value_changed.connect(func(_val: float): AudioBusManager.adjust_bus_volume("Effects", clamp(_val, 0, 1)))

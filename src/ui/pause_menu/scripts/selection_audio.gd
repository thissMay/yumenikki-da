extends UIStackNode

@export var music_slider: HSlider
@export var amb_slider: HSlider
@export var sfx_slider: HSlider

func _ready() -> void:
	super()
	
	music_slider.value 	= AudioBusManager.get_bus_volume("Music", true)
	amb_slider.value 	= AudioBusManager.get_bus_volume("Ambience", true)
	sfx_slider.value 	= AudioBusManager.get_bus_volume("Effects", true)
	
	music_slider.value_changed.connect(func(_val: float): AudioBusManager.adjust_bus_volume("Music", clamp(_val, 0, 1)))
	amb_slider.value_changed.connect(func(_val: float): AudioBusManager.adjust_bus_volume("Ambience", clamp(_val, 0, 1)))
	sfx_slider.value_changed.connect(func(_val: float): AudioBusManager.adjust_bus_volume("Effects", clamp(_val, 0, 1)))

class_name EVN_SetAudioBusEffects
extends Event

@export var bus_name: String
@export var bus_effects: Array[AudioEffect]
@onready var on_scene_unload := EventListener.new(self, "SCENE_CHANGE_REQUEST")

func _ready() -> void:
	on_scene_unload.do_on_notify(func(): 	
		for fx in AudioBusManager.get_bus_effect_count(bus_name):
			AudioBusManager.remove_bus_effect(bus_name, fx), "SCENE_CHANGE_REQUEST")

func _execute() -> void:
	for fx in range(bus_effects.size()):
		if bus_effects[fx] == null: continue
		AudioBusManager.add_bus_effect(bus_name, bus_effects[fx], fx)

class_name AudioBusManager
extends GameDependency

const BUS_MASTER 	:= &"Master"
const BUS_MUSIC 	:= &"Music"
const BUS_AMB 		:= &"Ambience"
const BUS_EFF 		:= &"Effects"
const BUS_UI 		:= &"UI"

static func adjust_bus_volume(_bus_name: String, _vol: float) -> void:
	if (AudioServer.get_bus_index(_bus_name)) >= 0:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(_bus_name), linear_to_db(_vol))
static func get_bus_volume(_bus_name: String) -> float:
	if (AudioServer.get_bus_index(_bus_name)) >= 0:
		return AudioServer.get_bus_volume_db(AudioServer.get_bus_index(_bus_name))
	return 0
	
static func get_bus_effect_count(_bus_name: String) -> int:
	if (AudioServer.get_bus_index(_bus_name)) >= 0:
		return AudioServer.get_bus_effect_count(AudioServer.get_bus_index(_bus_name))
	return -1 

static func adjust_bus_effect(_bus_name: String, _fx_indx: int, _fx_prop: String, _new_val: Variant):
	if ((AudioServer.get_bus_index(_bus_name)) >= 0 and 
		AudioServer.get_bus_effect_count(AudioServer.get_bus_index(_bus_name)) - 1 >= _fx_indx and
		AudioServer.get_bus_effect(AudioServer.get_bus_index(_bus_name), _fx_indx)):
		AudioServer.get_bus_effect(AudioServer.get_bus_index(_bus_name), _fx_indx).set(_fx_prop, _new_val)	

static func add_bus_effect(_bus_name: String, _fx: AudioEffect, _pos: int = -1) -> int:
	if _fx == null: return -1
	if (AudioServer.get_bus_index(_bus_name)) >= 0:			
		AudioServer.add_bus_effect(AudioServer.get_bus_index(_bus_name), _fx, _pos)
		return _pos
	return -1
static func remove_bus_effect(_bus_name: String, _fx_indx: int) -> void:
	if ((AudioServer.get_bus_index(_bus_name)) >= 0 and 
		AudioServer.get_bus_effect_count(AudioServer.get_bus_index(_bus_name)) - 1 >= _fx_indx and
		AudioServer.get_bus_effect(AudioServer.get_bus_index(_bus_name), _fx_indx)):
		AudioServer.remove_bus_effect(AudioServer.get_bus_index(_bus_name), _fx_indx)
		
static func clear_bus_from_all_effects(_bus_name: String) -> void:
	if (AudioServer.get_bus_index(_bus_name)) >= 0:
		for i in AudioServer.get_bus_effect_count(AudioServer.get_bus_index(_bus_name)) - 1:
			AudioServer.remove_bus_effect(AudioServer.get_bus_index(_bus_name), i)

static func has_bus_name(_bus_name: String) -> bool:
	return (AudioServer.get_bus_index(_bus_name)) >= 0 

static func set_effect_active(_bus_name: String, _fx_indx: int, _active: bool) -> void:
	if ((AudioServer.get_bus_index(_bus_name)) >= 0 and 
		AudioServer.get_bus_effect_count(AudioServer.get_bus_index(_bus_name)) - 1 >= _fx_indx and
		AudioServer.get_bus_effect(AudioServer.get_bus_index(_bus_name), _fx_indx)):
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index(_bus_name), _fx_indx, _active)

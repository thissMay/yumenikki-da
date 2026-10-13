class_name Player
extends Actor2D

#region ---- data variables ----

const ERR_SOUNDS := [
	preload("res://src/audio/se/voice_mado_no-1.WAV"), 
	preload("res://src/audio/se/voice_mado_no-2.WAV")]

#endregion ---- data variables ----

# ---- signals ----
signal quered_interact(_pl: Player, choice: int)

signal quered_sprint_start
signal quered_sprint_end

signal quered_sneak_start
signal quered_sneak_end

# ---- initial ----
func _enter_tree() -> void: 
	super()
	PlayerInstance.instance = self
	EventManager.invoke_event("PLAYER_UPDATED", self)

class Data:
	static var content: Dictionary = {		
		"innocent_killed" : 0,
		"hostile_killed" : 0,
		"effects" : [],
		}
	
	static var effects: Array[PLEffect]
	
	static func get_effects_as_path() -> PackedStringArray:
		var arr = []
		for i in effects:
			arr.append(i.resource_path)
		
		return arr

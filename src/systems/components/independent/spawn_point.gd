@tool

class_name SpawnPoint
extends Node2D
	
const GROUP_ID := "spawn_points"
	
@export_group("Scene Path and Spawn ID.")
@export_file("*.tscn") var scene_path: String
@export var connection_id: String = "default"

const TEXTURE: Texture2D = preload("res://src/systems/components/independent/pl_spawn.png")
	
func _notification(what: int) -> void:
	
	match what:
		
		NOTIFICATION_READY:
			set_process(false)
			add_to_group(GROUP_ID)
		
		NOTIFICATION_PREDELETE:
			remove_from_group(GROUP_ID)
			
		NOTIFICATION_DRAW:
			if Engine.is_editor_hint():
				draw_texture(
				TEXTURE, 
				-TEXTURE.get_size() / 2 - Vector2(0, 8), Color(modulate, 0.5))

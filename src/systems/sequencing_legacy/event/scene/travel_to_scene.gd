@tool

class_name EVN_GoToScene
extends Event

@export_tool_button("Synchronize Spawn Point Info.") var sync := __update_spawn_point_info
@export_file("*.tscn") var scene_path: String:
	set(_path): 
		scene_path = _path
		if spawn_point != null: spawn_point.scene_path = _path
@export var connection_id: String = "default":
	set(_id):
		connection_id = _id
		if spawn_point != null: spawn_point.connection_id = _id
@export var spawn_point: SpawnPoint

func _execute() -> void:
	EventManager.invoke_event("PLAYER_DOOR_USED", connection_id)
	SceneManager.change_scene_to(load(scene_path))
func _validate() -> bool:		
	if (scene_path.is_empty() or
		!ResourceLoader.exists(scene_path)):
			
		printerr("EVENT - TRAVEL SCENE :: Scene path does not exist or is empty!!")
		return false

		
	return true

# --
func __update_spawn_point_info() -> void:
	if spawn_point != null:
		spawn_point.connection_id 	= connection_id
		spawn_point.scene_path 		= scene_path
		

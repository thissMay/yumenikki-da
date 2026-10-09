@tool

class_name SpawnPoint
extends Node2D
	
@export_group("Scene Path and Spawn ID.")
@export_file("*.tscn") var scene_path: String
@export var connection_id: String = "default"

@export_group("Flags.")
@export var parent_instead_of_self: Node = self:
	set(_parent_instead): 
		if _parent_instead != null: parent_instead_of_self = _parent_instead
		else:						parent_instead_of_self = self
@export var as_sibling: bool = true
@export_subgroup("Direction")
@export var heading: Actor2D.compass_headings = Actor2D.compass_headings.SOUTH

const TEXTURE: Texture2D = preload("res://src/systems/components/independent/pl_spawn.png")
	
func _enter_tree() -> void: Utils.u_add_to_group(self, "spawn_points")
func _exit_tree() -> void: 	Utils.u_remove_from_group(self, "spawn_points")
	
func _ready() -> void:		
	set_process(false)
	if Engine.is_editor_hint(): queue_redraw()
	
func _draw() -> void:
	if Engine.is_editor_hint():
		draw_texture(
			TEXTURE, 
			-TEXTURE.get_size() / 2 - Vector2(0, 8), Color(modulate, 0.5))

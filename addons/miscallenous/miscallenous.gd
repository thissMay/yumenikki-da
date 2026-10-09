@tool
class_name Miscallenous
extends EditorPlugin

func _enter_tree() -> void:
	add_custom_types()
		
func _exit_tree() -> void:
	remove_custom_types()

func add_custom_types() -> void:
	add_custom_type("GameScene", 
		"Node", 
		preload("res://src/systems/scenes/game/game_scene.gd"), 
		preload("res://addons/miscallenous/editor/game_scene.png")
		)
	add_custom_type("AdditiveGameScene", 
		"Node", 
		preload("res://src/systems/scenes/game/game_additive_scene.gd"), 
		preload("res://addons/miscallenous/editor/game_scene_additive.png")
		)
	add_custom_type("Actor2D", 
		"CharacterBody2D", 
		preload("res://src/entities/sentient_base.gd"), 
		preload("res://addons/miscallenous/editor/sentient_base.png")
		)	
	add_custom_type("Event", 
		"Node", 
		preload("res://src/systems/sequencing/event_interface.gd"), 
		preload("res://addons/miscallenous/editor/event_flag.png")
		)
	add_custom_type("Sequence", 
		"Event", 
		preload("res://src/systems/sequencing/sequence_interface.gd"), 
		preload("res://addons/miscallenous/editor/sequence_flag.png")
		)
	add_custom_type("SpawnPoint", 
		"Node2D", 
		preload("res://src/systems/components/independent/spawn_point.gd"), 
		preload("res://addons/miscallenous/editor/spawn_point.png")
		)
	add_custom_type("Interactable", 
		"AreaRegion", 
		preload("res://src/systems/interaction/interactable.gd"), 
		preload("res://addons/miscallenous/editor/interactable.png"), 
		)

func remove_custom_types() -> void:
	remove_custom_type("GameScene")
	remove_custom_type("AdditiveGameScene")
	remove_custom_type("Actor2D")
	remove_custom_type("Event")
	remove_custom_type("Sequence")
	remove_custom_type("SpawnPoint")
	remove_custom_type("Interactable")

@tool
class_name Autoloads
extends EditorPlugin

const SCRIPT_REFERENCES: Dictionary[String, String] = {
	"Utils" 			: "res://src/systems/utils/utils.gd",
	"GameBootstrapper" 	: "res://autoloads/game_bootstrapper.gd",
	"Global" 			: "res://autoloads/global.gd",
	"SceneManager" 		: "res://autoloads/scene_manager.gd",
	"AudioService" 		: "res://autoloads/audio_service.gd",
	"NodeSaveService" 	: "res://autoloads/node_save_service.gd",
}

func _enter_tree() -> void: for i in SCRIPT_REFERENCES: add_autoload_singleton(i, SCRIPT_REFERENCES[i])
func _exit_tree() -> void: 	for i in SCRIPT_REFERENCES.keys(): remove_autoload_singleton(i)

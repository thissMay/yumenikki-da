@tool
class_name Autoloads
extends EditorPlugin

const SCRIPT_REFERENCES: Dictionary[String, String] = {
	"Utils" 			: "res://src/systems/utils/utils.gd",
	"GameBootstrapper" 	: "res://autoloads/game_bootstrapper.gd",
	"GlobalSignals" 	: "res://autoloads/global_signals.gd",
	"Global" 			: "res://autoloads/global.gd",
	"SceneLoader" 		: "res://autoloads/scene_loader.gd",
	"AudioService" 		: "res://autoloads/audio_service.gd",
	"SceneSaver" 		: "res://autoloads/scene_saver.gd",
}

func _enter_tree() -> void: 
	if !Engine.is_editor_hint(): return
	for i in SCRIPT_REFERENCES: add_autoload_singleton(i, SCRIPT_REFERENCES[i])

func _exit_tree() -> void: 	
	if !Engine.is_editor_hint(): return
	for i in SCRIPT_REFERENCES.keys(): remove_autoload_singleton(i)

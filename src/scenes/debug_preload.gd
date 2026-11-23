@tool
extends SceneNode

# -- 
@export_group("Pre-game Warning Section.")
@export var timer: Timer
# -- 
@export_group("Preloading Content Section.")
@export var shader_garbage_placeholder: Node2D

const LOADING_INTERVAL := 0.02

const SHADERS_PATH := "res://src/shaders/"
const CACHED_SHADER_PATH := "user://shader_cache.txt"

const MAX_SCENES_TO_LOAD := 3

var shaders: PackedStringArray
var scenes: PackedStringArray

signal shader_finished

func _ready() -> void:
	shader_finished.connect(
		func():
			AudioService.play_sound(load("res://src/audio/ui/ui_instructions.WAV"))
			EventManager.invoke_event("GAME_PRELOADING_CONTENT_FINISH")
			print("Preloading content finished!")

	)

func _on_push() -> void:
	super()
	await get_tree().create_timer(.5).timeout
	
	shader_garbage_placeholder.material = ShaderMaterial.new()
	shader_garbage_placeholder.texture 	= preload("res://game_icon.png")
	
	await gather_all_shaders(0, DirAccess.get_directories_at(SHADERS_PATH))
	
	
func gather_all_shaders(index: int, directory: PackedStringArray) -> void:
	if (index >= directory.size()):
		shader_finished.emit()
		return 
	
	var files: PackedStringArray = DirAccess.get_files_at(SHADERS_PATH + directory[index])
	for i: String in files:
		if i.ends_with(".gdshader"): shader_garbage_placeholder.material.shader = load(SHADERS_PATH + directory[index] + "/" + i)
		await get_tree().process_frame
		
	await get_tree().create_timer(LOADING_INTERVAL).timeout
	
	gather_all_shaders(index + 1, directory)	

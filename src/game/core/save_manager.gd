class_name Save
extends GameDependency

static var TEMPLATE_DATA := {
	"version" 	: "DEFAULT",
	"game" 		: 
		{
		"completed" 	: false,
		"read_warning" 	: false,
		"time_played" 	: 00,
		},
	"global" 	: 
		{
		"flags" : {}
		},
	"player" 	: {},
	"scene" 	: {}}

static var time_elapsed: float
static var data		: Dictionary
static var curr_data: Dictionary

const SAVE_DIR := "user://save/"
static var save_files: Array

static func _setup() -> void:
	time_elapsed = 0
	
	data = TEMPLATE_DATA.duplicate()
	if !DirAccess.dir_exists_absolute(SAVE_DIR): 
		DirAccess.make_dir_absolute(SAVE_DIR)

static func save_data(_number: int = 0) -> void: pass
	#if !DirAccess.dir_exists_absolute(SAVE_DIR): 
		#DirAccess.make_dir_absolute(SAVE_DIR)
	#
	#if curr_data.is_empty(): curr_data = data.duplicate()
	#var save_data_file := FileAccess.open(str(SAVE_DIR, "save_%s.json" % [_number]), FileAccess.WRITE)
	#
	#curr_data["version"] = Game.GAME_VER
	#curr_data["game"]["time_played"] = time_elapsed
		#
	#curr_data["player"] = Player.Data.content
	#curr_data["player"]["effects"] = Player.Data.get_effects_as_path()
	#curr_data["scene"] = NodeSaveService.data
	#
	#save_data_file.store_string(JSON.stringify(curr_data, "\t"))
	#save_data_file.close()
	#save_data_file = null

	#EventManager.invoke_event("GAME_FILE_SAVE", curr_data)
#static func load_data(_number: int = 0) -> Error:
	#if FileAccess.file_exists(str(SAVE_DIR, "save_%s.json" % [_number])): 
		#var load_file := FileAccess.open(str(SAVE_DIR, "save_%s.json" % [_number]), FileAccess.READ)
		#var content = JSON.parse_string(load_file.get_as_text())
		#curr_data = content
		#
		#load_file.close()
		#load_file = null
#
		#if !verify_data_version(curr_data):
			#return ERR_CANT_OPEN
		#
		#time_elapsed 			= content["game"]["time_played"]
		#Player.Data.content 	= content["player"]
		#NodeSaveService.data 	= content["scene"]
		#
	#else: return ERR_CANT_OPEN
	#return OK

static func get_data_as_json(_json_file_name: String) -> JSON:
	var json_file_path := str(SAVE_DIR, "%s.json" % [_json_file_name])
	if json_file_path.is_empty() or json_file_path == ".json": return
	
	return ResourceLoader.load(json_file_path)
static func get_data(_number: int = 0) -> Dictionary:
	var load_file := FileAccess.open(str(SAVE_DIR, "save_%s.json" % [_number]), FileAccess.READ)
	var content = JSON.parse_string(load_file.get_as_text())
	return content

static func clear_data() -> Error:
	data = TEMPLATE_DATA
	return OK

static func change_data_value(_key: String, _val: Variant) -> void:
	if !_key in data: return
	data[_key] = _val 
static func read_data_value(_key: String) -> Variant:
	if !_key in data: return
	return data[_key]

# - helper
static func verify_data_version(_data: Dictionary) -> bool:
	if _data.is_empty(): return false
	
	#if  _data.has("version"):
		#return _data["version"] == Game.GAME_VER
		
	return false

static func get_time_elapsed_in_HMS() -> Dictionary:
	return {
		"hours" 	: floori(fmod(time_elapsed / 3600, 24)),
		"minutes" 	: floori(fmod(time_elapsed, 3600) / 60),
		"seconds" 	: floori(fmod(fmod(time_elapsed, 3600), 60))
	}

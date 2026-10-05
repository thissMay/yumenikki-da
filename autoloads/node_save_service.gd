extends Node

const NODE_SAVE_GROUP_ID 	:= &"save_requests"
const GLOBAL_DIR 			:= &"global"

var data := {
	GLOBAL_DIR	: {"data" : {}}
	}

var scene_data_template := {
	"data" 	: {},
	"deleted_nodes_id" : [],
	"instantiated_nodes_id" : [],
	}

func save_scene_data(_scene: SceneNode) -> void: 
	var node_saves: = Utils.get_group_arr(NODE_SAVE_GROUP_ID)
	var scene_path: StringName = _scene.scene_file_path
		
	data[scene_path] = Dictionary(scene_data_template)
	
	for node: SaveRequest in node_saves: 
		if node == null: continue
		var save_dict: Dictionary = node.save_data()
		for key in save_dict.keys():
			
			if node.global:		data[NodeSaveService.GLOBAL_DIR]["data"][key] 	= save_dict[key]
			else:				data[scene_path]["data"][key] 					= save_dict[key]
				
func load_scene_data(_scene: SceneNode) -> void:
	var node_saves = Utils.get_group_arr(NODE_SAVE_GROUP_ID) as Array[SaveRequest]
	var scene_path: StringName = _scene.scene_file_path
	
	if !data.has(scene_path): return
	if data[scene_path]:
		for node: SaveRequest in node_saves: 
			if node != null: node.load_data(_scene)

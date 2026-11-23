class_name NodeDeletedSave
extends NodeSave


func load_data(scene: SceneNode) -> Error:
	parent = get_parent()
	if parent == null: return ERR_UNAVAILABLE
		
	var saved_data: Variant
	
	if global: 	saved_data = SceneSaver.data[SceneSaver.GLOBAL_DIR]		["data"]
	else:		saved_data = SceneSaver.data[scene.scene_file_path]	["data"]
	
	if !saved_data.has(parent.name): return ERR_DOES_NOT_EXIST
	
	var saved_properties = saved_data[parent.name]

	for prop in saved_properties:
		parent.set_indexed(prop, saved_properties[prop])
		
	return OK

func save_data() -> Dictionary:
	parent = get_parent()
	if parent == null: 
		print(self, " : properties are empty or parent doesn't exist!")
		return {}
	
	data[parent.name] = {}
	
	return data

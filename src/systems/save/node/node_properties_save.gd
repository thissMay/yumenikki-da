class_name NodePropertiesSave
extends NodeSave

@export var properties: PackedStringArray

func load_data(_scene: SceneNode) -> Error:
	parent = get_parent()
	if parent == null or properties.is_empty(): return ERR_UNAVAILABLE
		
	var saved_data
	
	if global: 	saved_data = SceneSaver.data[SceneSaver.GLOBAL_DIR]		["data"]
	else:		saved_data = SceneSaver.data[_scene.scene_file_path]	["data"]
	
	if !saved_data.has(parent.name): return ERR_DOES_NOT_EXIST
	
	var saved_properties = saved_data[parent.name]

	for prop in saved_properties:
		parent.set_indexed(prop, saved_properties[prop])
		
	return OK

func save_data() -> Dictionary:
	parent = get_parent()
	if parent == null or properties.is_empty(): 
		print(self, " : properties are empty or parent doesn't exist!")
		return {}
	
	data[parent.name] = {}
	
	for p : NodePath in properties: 
		data[parent.name][p] = parent.get_indexed(p)
		
	return data

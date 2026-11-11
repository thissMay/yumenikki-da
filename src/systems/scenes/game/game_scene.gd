@tool

class_name GameScene
extends SceneNode

@export_group("On Load \\ Free Sequences.")
@export_tool_button("Create On-Initial") var create_initial: Callable 	= create_on_initial
@export_tool_button("Create On-Free") 	 var create_free: Callable 		= create_on_free
@export var seq_initial	: Sequence
@export var seq_free	: Sequence

@export_group("Transitions.")

# - scene exclusive objects.
# sequences
func create_on_initial() -> void:
	seq_initial = Utils.get_child_node_or_null(self, "on_initial")
	if !Engine.is_editor_hint() or seq_initial != null: 
		seq_initial.skip_invalid_events = true
		return
	
	seq_initial =  Utils.add_child_node(self, Sequence.new(), "on_initial")
	seq_initial.skip_invalid_events = true
	
func create_on_free() -> void:
	seq_free = Utils.get_child_node_or_null(self, "on_free")
	if !Engine.is_editor_hint() or seq_free != null: 
		seq_free.skip_invalid_events = true
		return
	
	seq_free =  Utils.add_child_node(self, Sequence.new(), "on_free")
	seq_free.skip_invalid_events = true

# - stack functions.	
func _on_push() -> void: 
	load_scene()
	save_scene()
	
	if seq_initial != null: SequencerManager.invoke(seq_initial)
	super()
func _on_pre_pop() -> void: 
	if seq_free != null: SequencerManager.invoke(seq_free)

func _on_pop() -> void:
	save_scene()
	queue_free()
	super()
	
# - saving. 
func save_scene() -> void: NodeSaveService.save_scene_data(self)
func load_scene() -> void: NodeSaveService.load_scene_data(self)

@tool
@icon("res://addons/miscallenous/editor/loop_manager.png")

class_name LoopRegion
extends Node2D

@export_group("Loop Component Updates and Setups.")
@export_tool_button("Update Collection (+ Set As Region).") var update_loopables_collection := update_loopable_collection
@export_tool_button("Update Loop Duplicate Info.") 			var update_loopables_world_size := update_loopable_world_size
@export_tool_button("Update Loop Duplicates' Properties.") 	var update_loopables  			:= update_loopable_components
@export_tool_button("Setup Components.") 					var setup_loopables  	 		:= setup_loopable_components

@export_group("Drawing Options.")
@export var safe_zone_colour: 	Color = Color("76b4001d")
@export var region_colour: 		Color = Color("327aae5e")
@export var omitted_colour:		Color = Color("25293271")

#@export_group("Loop Component Visibility.")
#@export_tool_button("Show All Duplicates") var show_dupes
#@export_tool_button("Hide All Duplicates") var hide_dupes

const LOOP_UNIT_VECTOR := [
	Vector2(-1, -1), Vector2(0, -1), Vector2(1, -1),
	Vector2(-1, 0), Vector2(1, 0),
	Vector2(-1, 1), Vector2(0, 1), Vector2(1, 1)
]

const SAFE_ZONE = Vector2(550, 350)

@export_group("Info.")
@export var loop_objects: Array[Node]:
	set(_objs): 
		loop_objects = _objs
		if _objs.is_empty(): 	
				self.set_process		(false)
				self.set_physics_process(false)
		else:
				self.set_process		(true)
				self.set_physics_process(true)
@export var world_size: Vector2 = Vector2(100, 100):
	set = set_world_size

# - signals.
signal update_dupe_nodes

# -- 
func _ready() -> void: 
	update_loopable_collection()

	
func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint(): queue_redraw()
	else: 						update_dupe_nodes.emit()
		
	for l in range(loop_objects.size()):
		var loopable: LoopableComponent = loop_objects[l] 
		if loopable == null or loopable.do_not_loop: continue
		
		if loopable.target is CanvasItem and !loopable.do_not_loop:
			
			var min_pos = -self.world_size / 2 + self.global_position
			var max_pos =  self.world_size / 2 + self.global_position
			
			loopable.target.global_position.x = wrap(loopable.target.global_position.x, min_pos.x, max_pos.x)
			loopable.target.global_position.y = wrap(loopable.target.global_position.y, min_pos.y, max_pos.y)
func _draw() -> void:
	if Engine.is_editor_hint(): 
		# - safe zone.
		draw_rect(Rect2(-(world_size + SAFE_ZONE * 2) / 2, world_size + SAFE_ZONE * 2), safe_zone_colour)
				
		# region size.
		draw_rect(Rect2(-(world_size) / 2, world_size), region_colour)
		draw_rect(Rect2(-(world_size) / 2 + SAFE_ZONE / 4, world_size - SAFE_ZONE / 2), omitted_colour)

# --- 									
func set_world_size(_size: Vector2) -> void:
	world_size = _size.round()
	for loopable: LoopableComponent in loop_objects:
		if 	loopable != null:
			loopable.world_size = _size

# - loop components exclusive.
func update_loopable_collection() -> void: 
	loop_objects = Utils.get_group_array(LoopableComponent.LOOPABLE_ID)
	
	for l in range(loop_objects.size()):
		var loopable: LoopableComponent = loop_objects[l]
		if 	loopable == null: continue
		loopable.assign_region(self)
		loopable.idx = l
func update_loopable_world_size() -> void:
	set_world_size.call_deferred(world_size)
func update_loopable_components() -> void: 
	update_dupe_nodes.emit()

func setup_loopable_components() -> void: 
	for i: LoopableComponent in loop_objects:
		i.setup_loop_nodes(world_size)
		set_world_size(world_size)
	
	# TODO: rework..
	# band-aid fix.
	update_loopable_collection.call_deferred()
	

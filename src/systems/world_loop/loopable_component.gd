@tool
@icon("res://addons/miscallenous/editor/loopable_component.png")

# - this component will be handled from a different manager.
class_name LoopableComponent
extends Node2D

@export_tool_button("Setup Loop Component") var setup_pre_game = setup_loop_nodes
@export_tool_button("Update Properties") var update_props = update_duplicates

const LOOPABLE_ID := &"loop_components"
const ROW_NODES = [3, 4]
const COL_NODES = [1, 6]
const COR_NODES = [0, 2, 5, 7]

@export var region: LoopRegion
@export_storage var idx: int = 0

# - the nodes and their properties.
@export_group("Target and Properties Info")
@export var target: Node
@export var children: Array[Node]
@export var properties: PackedStringArray 

@export_group("Duplicates and Occlusion Array")
@export var dupe_nodes: Array[Node]
@export var occlusions: Array[VisibleOnScreenNotifier2D]

# - flags.
@export_group("Flags")

@export_subgroup("Loop.")
@export var do_not_loop:				bool = false
@export var do_not_dupe: 				bool = false:
	get:
		if target == null or !target is CanvasItem: return true
		return do_not_dupe
@export var do_not_update: 				bool = true:
	set(no_update):
		do_not_update = no_update
		if region == null: return
		if no_update:	 	Utils.disconnect_from_signal(update_duplicates, region.update_dupe_nodes)
		else:				Utils.connect_to_signal		(update_duplicates, region.update_dupe_nodes)

@export_subgroup("Visibility.")
@export var hide_centre_row: 		bool = false:
	set(_hide):
		hide_centre_row = _hide
		for i in range(dupe_nodes.size()):
			if i in ROW_NODES and dupe_nodes[i] != null: dupe_nodes[i].visible = !_hide
@export var hide_centre_column: 		bool = false:
	set(_hide):
		hide_centre_column = _hide
		for i in range(dupe_nodes.size()):
			if i in COL_NODES and dupe_nodes[i] != null: dupe_nodes[i].visible = !_hide
@export var hide_corner_entries: 		bool = false:
	set(_hide):
		hide_corner_entries = _hide
		for i in range(dupe_nodes.size()):
			if i in COR_NODES and dupe_nodes[i] != null: dupe_nodes[i].visible = !_hide

@export_subgroup("Misc.")
@export var do_not_include_occlusions: 	bool = false
@export var keep_child_nodes: 			bool = false

#  - readonly.
@export_group("Read-Only")
@export var world_size: Vector2:
	set = __set_size

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			if 	region != null:
				region.loop_objects[idx] = null
func _ready() -> void:
	self.y_sort_enabled = true
	do_not_update = do_not_update
	
	# TODO: needs ton of work.
	#if !Engine.is_editor_hint():
		#for i in range(occlusions.size()):
			#
			#var occlusion = occlusions[i]
			#var dupe_node = dupe_nodes[i]
			#
			#if dupe_node != null and occlusion != null:
				#
				#Utils.connect_to_signal(__hide_line_dupe_nodes.bind(i, true), 	occlusion.screen_exited)
				#Utils.connect_to_signal(__hide_line_dupe_nodes.bind(i, false), 	occlusion.screen_entered)
				#
			#__hide_line_dupe_nodes(-1, true)

func _enter_tree() -> void:	
	add_to_group(LOOPABLE_ID)
	target 		= self.get_parent()
	children 	= target.get_children()
	children.remove_at(children.find(self))
	
func _exit_tree() -> void: 	
	remove_from_group(LOOPABLE_ID)
	
func assign_region(_region: LoopRegion) -> void:
	if 	region != null: 
		if region != _region: 	region.loop_objects[idx] = null
	
	region 	= _region

func setup_loop_nodes(_world_size: Vector2) -> void:
	# - we clear and free the old duplicated nodes list.
	if do_not_dupe or !(target is CanvasItem) : return
	children 	= target.get_children()
	children.remove_at(children.find(self))
	
	var first_dupe: Node = null
	dupe_nodes.resize(8)
	occlusions.resize(8)
	
	# - we create the duplicated nodes.
	for i in range(8):
		
		# - we get any dupes already existent.
		# - if it already exists, then skip it.
		var dupe = Utils.get_child_node_or_null(self, "loop_%s_%s" % [target.name, i])
		
		if 		dupe != null or dupe_nodes.has(dupe): 	
			dupe_nodes[i] = dupe
			continue
		
		# -- 
		if 	first_dupe == null:
			first_dupe = Utils.add_child_node(self, target.duplicate(), "loop_%s_%s" % [target.name, i])
			first_dupe.visible = true
			dupe = first_dupe
		else:
			dupe = Utils.add_child_node(self, first_dupe.duplicate(), "loop_%s_%s" % [target.name, i])
		
		if keep_child_nodes: 
			var duped_loop: LoopableComponent = dupe.get_node_or_null(str(self.name))
			if	duped_loop in dupe.get_children(): 
				duped_loop.region = null
				duped_loop.free()
		else: 
			for c in dupe.get_children(): c.free() 
	
		for c in dupe.get_children(): 
			c.owner = self.owner
			c.set_meta("_edit_lock_", true)
			
		dupe_nodes[i] = dupe
		dupe_nodes[i].set_meta("_edit_lock_", true)
		
	# -- oclussions.
	if !do_not_include_occlusions:
		for i in range(8):
			if 	dupe_nodes[i] != null:
				occlusions[i] = Utils.get_child_node_or_null(dupe_nodes[i],  "occlusion")
				
				if 	occlusions[i] == null:
					occlusions[i] = Utils.add_child_node(dupe_nodes[i], VisibleOnScreenNotifier2D.new(), "occlusion")
				
				occlusions[i].self_modulate.a = 0.2
	update_duplicates()
	__set_size(_world_size)
	
func update_duplicates() -> void: 
	for i in range(dupe_nodes.size()):
		var dupe_node = dupe_nodes[i]
		
		if children.size() > 0: 
			for c in children.size():
				var child = Utils.get_child_node_or_null(dupe_node, children[c].name)
				if child == null: continue
				for p in properties:
					if child.get_indexed(p) == null: continue
					child.set_indexed(p, children[c].get_indexed(p))
		else:
			for p in properties:
				if target.get_indexed(p) == null: continue
				dupe_node.set_indexed(p, target.get_indexed(p))	
func update_loop_nodes_list(_loop_node) -> void:
	if _loop_node in dupe_nodes:
		dupe_nodes[dupe_nodes.find(_loop_node)] = null

# - internal
func __set_size(_size: Vector2) -> void: 
	world_size = _size
	if do_not_dupe: return
	
	for i in dupe_nodes.size():
		if 	dupe_nodes[i] != null:
			dupe_nodes[i].global_position = target.global_position + world_size * region.LOOP_UNIT_VECTOR[i]
			
			if 	occlusions[i] == null: continue
			occlusions[i].rect.size = _size * 1.25
			occlusions[i].rect.position = -occlusions[i].rect.size / 2
#func __hide_line_dupe_nodes(_idx: int, _hide: bool = true) -> void:
	#var dupes_idx = []
	#var node = null
	#if (_idx in ROW_NODES or _idx == -1) and !hide_centre_row: 		dupes_idx.append_array(ROW_NODES)
	#if (_idx in COL_NODES or _idx == -1) and !hide_centre_column: 	dupes_idx.append_array(COL_NODES)
	#if (_idx in COR_NODES or _idx == -1) and !hide_corner_entries: 	dupes_idx.append_array(COR_NODES)
	#
	#for i in dupes_idx:
		#for k in children: 
			#
			#if k != null: 
				#node = Utils.get_child_node_or_null(dupe_nodes[i], k.name)
				#if node == null: return
				#
				#match _hide:
					#true: 	node.hide()
					#false: 	node.show()
#func __hide_dupe_nodes(_idx: int, _hide: bool = true) -> void:
	#for k in children: 
		#if k != null: 
			#var node = Utils.get_child_node_or_null(dupe_nodes[_idx], k.name)
			#if node == null: 
				#return
			#
			#match _hide:
				#true: 	if !occlusions[_idx].is_on_screen(): node.hide()
				#false: 	node.show()

# - misc.
func disable_loop() -> void: 	do_not_loop = true
func enable_loop() -> void: 	do_not_loop = false

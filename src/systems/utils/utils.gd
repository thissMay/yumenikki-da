@tool
extends Node

var ignore_warnings: bool = true

func is_within_exclusive(_num: float, _min: float, _max: float) -> bool:
	return ((_num < _min) and (_num > _max))
func is_within_inclusive(_num: float, _min: float, _max: float) -> bool:
	return ((_num <= _min) and (_num >= _max))

# editor-hint exclusive
func add_sibling_node(
	_target_node: 	Node,
	_sibling_node: 	Node,
	_sibling_node_name: String) -> Node:
		var node_as_sibling: Node
		if _target_node == _target_node.owner: 	node_as_sibling = _target_node
		else:									node_as_sibling = _target_node.get_parent()
		
		return add_child_node(node_as_sibling, _sibling_node, _sibling_node_name)
func add_child_node(
	_parent_node: 	Node,
	_child_node: 	Node,
	_child_node_name: String) -> Node:
		# - bail if parent or child node are non-existent.
		var _owner
		if Engine.is_editor_hint(): _owner = Engine.get_singleton("EditorInterface").get_edited_scene_root()
		else: 						_owner = _parent_node.owner
		
		if _child_node == null or _parent_node == null:
			push("Child node or Parent node do not exist!")
			return

		
		if !_parent_node.has_node(_child_node_name):
			_parent_node.add_child(_child_node, true)
			_child_node.name 	= _child_node_name
			_child_node.owner 	= _owner
			return _child_node
			
		else:
			push("Parent %s already has child %s - Freeing queued %s." % [_parent_node, _child_node_name, _child_node])
			_child_node.queue_free()
			return _parent_node.get_node(_child_node_name)
func get_child_node_or_null(
	_parent_node: Node,
	_child_node_name: String) -> Node:
		var _child_node: Node
		
		if _parent_node == null or _child_node_name.is_empty():
			push("Parent is null or Child node could not be found.")
			return null
		return _parent_node.get_node_or_null(_child_node_name)

# signals
func connect_to_signal(
	_conectee: Callable,
	_signal: Signal,
	_flags: int = 0,
	_allow_lambda: bool = true) -> void:
	
	if _signal.is_connected(_conectee):
		push("GLOBAL UTILS: Callable %s is already connected to signal %s." % [_conectee, _signal])
		return
	
	if !_allow_lambda:
		if 	_conectee.get_object() == null:
			push("GLOBAL UTILS: Lambda callable %s restricted from connecting to signal." % [_conectee])
			return
			
	_signal.connect(_conectee, _flags)
func disconnect_from_signal(
	_conectee: Callable,
	_signal: Signal) -> void:
		if !_signal.is_connected(_conectee):
			push("GLOBAL UTILS: Callable %s is not connected to signal %s!" % [_conectee, _signal])
			return
		_signal.disconnect(_conectee)

# - groups
func u_add_to_group(_node: Node, _name: String, _persist: bool = false) -> void:
	if _node.is_in_group(_name):
		push("GLOBAL UTILS: Node %s is already in group %s!" % [_node, _name])
		return
	_node.add_to_group(_name, _persist)
func u_remove_from_group(_node: Node, _name: String) -> void:
	if 	_node.is_in_group(_name):
		_node.remove_from_group(_name)

func get_group_arr(_name: String) -> Array[Node]:
	if get_tree().has_group(_name):
		return get_tree().get_nodes_in_group(_name)
	return [null]

# - helper.
func push(...a: Array) -> void:
	if !ignore_warnings: push_warning(a)

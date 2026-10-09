class_name SM
extends RefCounted

var root: State

func _init(root: State) -> void:
	self.root = root

func change_state(from: State, to: State) -> void: 
	if (from == to || from == null || to == null): return
	var common: State = LCA(from, to)
	var curr: State = from
	var stack: Stack = to.trace_up_to(common)
	
	while (curr != common):
		curr.exit()
		curr = curr.parent
		
	while (!stack.is_empty()):
		(stack.pop() as State).enter()
		
	
func LCA (a: State, b: State) -> State: 
	var state_set: Set = Set.new()
	var first: State = a
	var check: State = a
	
	while (first.parent != null):
		state_set.add(first)
		first = first.parent
		
	while (check.parent != null):
		if state_set.contains(check): return check
		check = check.parent
	
	return null


# -- static functions
static func build(root: State) -> SM:
	var sm := SM.new(root)
	wire(root, sm, Set.new())
	return sm


static func wire(s: State, m: SM, visited: Set) -> void: 
	if (s == null): return
	if (!visited.add(s)): return 
	
	s.machine = m
	
	for p in s.get_property_list():
		if p["class_name"] != "State": continue
		if p["name"] == "parent" or p["name"] == "active": continue
		
		var child: State = s.get(p["name"])  
		
		if child == null or s != child.parent: continue
		
		wire(child, m, visited)	

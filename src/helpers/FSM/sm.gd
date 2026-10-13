class_name SM
extends RefCounted

var root: State
var started: bool = false

func _init(root: State) -> void:
	self.root = root

func start() -> void:
	if started: return 
	started = true
	
	root.enter()

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
	if (a == b): return
	
	var state_set: Set = Set.new()
	
	while (a != null):
		state_set.add(a)
		a = a.parent
		
	while (b != null):
		if state_set.contains(b): return b
		b = b.parent
	
	return null
func leaf() -> State:
	var r: State = root
	while r.active  != null:
		r = r.active 
	return r

func update(_delta: float) -> void: 		root.update(_delta)
func phys_update(_delta: float) -> void: 	root.phys_update(_delta)
func input_pass(_event: InputEvent):		root.input(_event)

# -- static functions
static func build(root: State) -> SM:
	var sm := SM.new(root)
	r_wire(root, sm, Set.new())
	return sm
static func r_wire(s: State, m: SM, visited: Set) -> void: 
	if (s == null): return
	if (!visited.add(s)): return 
	
	s.sm = m
	
	for p in s.get_property_list():
		if p["class_name"] != "State": continue
		if p["name"] == "parent" or p["name"] == "active": continue
		
		var child: State = s.get(p["name"])  
		
		if child == null or s != child.parent: continue
		
		r_wire(child, m, visited)	
		

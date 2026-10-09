@abstract
class_name State
extends RefCounted

var machine: SM
var parent: State
var active: State

var entered: bool

func _init(machine: SM, parent: State):  
	self.machine = machine
	self.parent = parent

func enter() -> void: 
	if entered: return
	entered = true
	
	if parent != null: parent.active = self
	on_enter()
	
	var init_state: State = get_initial()
	if (init_state != null): machine.to(init_state) 
	
func exit() -> void: 
	entered = false 
	
	on_exit()
	if parent != null: parent.active = null

func phys_update(_delta: float) -> void: 
	on_phys_update(_delta)
func update(_delta: float) -> void:
	var t: State = get_transition() 
	on_update(_delta)
	
	if t != null:
		machine.change_state(self, t)
func input(_event: InputEvent) -> void: pass

#region virtual functions
func on_enter() -> void: pass
func on_exit() -> void: pass
func on_phys_update(_delta: float) -> void: pass
func on_update(_delta: float) -> void: pass
func on_input() -> void: pass

func get_initial() -> State: return null
func get_transition() -> State: return null
#endregion

func trace_up_to(s: State) -> Stack:
	var stack := Stack.new()
	var curr := self
	while curr != s:
		stack.push(curr)
		curr = curr.parent
	
	return stack

func root() -> State:
	if parent == null: 
		return null # it means this is the root
	
	var s: State = self
	while (s.parent != null):
		s = s.parent
		
	return s
	
func to_path() -> String:
	var s: State = self
	var t: String = ""
	
	while (s != null):
		t += "%s > " % s.get_class()
		s = s.parent
		
	return ""
	
func name() -> String: return ""

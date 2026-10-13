@abstract
class_name State
extends RefCounted

var sm: SM
var parent: State
var active: State

var entered: bool

func _init(sm: SM, parent: State):  
	self.sm = sm
	self.parent = parent

func enter() -> void: 
	if entered: return
	entered = true
	
	if parent != null: parent.active = self
	on_enter()
	
	var init_state: State = get_initial()
	if (init_state != null): sm.change_state(self, init_state) 
	
func exit() -> void: 
	entered = false 
	
	if active != null: active.exit()
	active = null
	
	on_exit()

func phys_update(_delta: float) -> void: 
	on_phys_update(_delta)
	if (active != null): active.phys_update(_delta)	
	
func update(_delta: float) -> void:
	var t: State = get_transition() 
	
	if t != null:
		sm.change_state(self, t)
	
	if (active != null): active.update(_delta)	
	on_update(_delta)
		
func input(_event: InputEvent) -> void: 
	if (active != null): active.on_input(_event)	
	on_input(_event)

#region virtual functions
func on_enter() -> void: pass
func on_exit() -> void: pass
func on_phys_update(_delta: float) -> void: pass
func on_update(_delta: float) -> void: pass
func on_input(_event: InputEvent) -> void: pass

func get_initial() -> State: return null
func get_transition() -> State: return null
#endregion

func trace_up_to(s: State) -> Stack:
	var stack := Stack.new()
	var curr : State = self
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
	
func leaf() -> State:
	var r: State = active
	while(r.active != null): r = r.active
	return r
	
func to_path() -> String:
	var s: State = self
	var t: String = ""
	
	while (s != null):
		t += "%s > " % s.get_class()
		s = s.parent
		
	return ""
	
func has_connection_to(state_name: String) -> bool:
	return false

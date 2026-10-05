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
	

func phys_update(_delta: float) -> void: pass
func update(_delta: float) -> void: pass
func input(_event: InputEvent) -> void: pass

# -- virtual functions (override these ones)
func on_enter() -> void: pass
func on_exit() -> void: pass
func on_phys_update() -> void: pass
func on_update() -> void: pass
func on_input() -> void: pass

func get_initial() -> State: return null
func get_transition() -> State: return null

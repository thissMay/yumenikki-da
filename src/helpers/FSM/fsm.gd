class_name SM 
extends Node

@export var track_state_changes: bool = false

var context: Node

signal state_changed(_new_state)
signal setup

var is_setup: bool = false

var state_dict: Dictionary[StringName, LegacyState]
var prev_state: LegacyState
var curr_state: LegacyState
@export var initial_state: LegacyState

func _init(init_state: LegacyState = null) -> void: initial_state = init_state

# - initial
func _setup(_owner: Node, _skip_initial_state_setup: bool = false) -> void:
	set_process			(false)
	set_physics_process	(false)
	
	if track_state_changes:
		state_changed.connect(
			func(_state): print(self, " - LegacyState changed! [%s] --> [%s]" % [curr_state, _state]))
	context = _owner
	
	for states in self.get_children():
		if states is LegacyState:
			states.fsm = self 
			state_dict[states.name.to_lower()] = states 
			states.setup()
			
	curr_state = initial_state
	if curr_state != null and !_skip_initial_state_setup: 
		curr_state.state_enter()
		
		
func change_state(from: State, state: State) -> void: pass
func LCA (a: State, b: State) -> State: return null
		
func change_to_state(_new: StringName) -> void:
	_new = _new.to_lower()
	if !_new.is_empty() and has_state(_new):
		var new_state: LegacyState = state_dict.get(_new)

		if curr_state == new_state: 
			return
		
		state_changed.emit(new_state)	
		if curr_state != null: curr_state.state_exit()
		
		prev_state = curr_state
		curr_state = new_state
		
		curr_state.state_enter()
			
# - state checks + getter
func has_state(_state_id: StringName) -> bool:
	return _state_id in state_dict
func is_in_state(_state_id: StringName) -> bool:
	return curr_state == state_dict.get(_state_id.to_lower())

func get_state(_state_id: StringName) -> LegacyState:
	if has_state(_state_id.to_lower()): return state_dict[_state_id.to_lower()] 
	return
func get_curr_state() -> LegacyState: 
	return curr_state
func get_curr_state_name() -> StringName: 
	if get_curr_state() == null: return str("%s:: no state bound" % self)
	return state_dict.find_key(curr_state)


# - dependent update / process
func _update(_delta: float) -> void: 
	if curr_state != null: curr_state.state_update(_delta)
func _physics_update(_delta: float) -> void: 
	if curr_state != null: curr_state.state_physics_update(_delta)
func _input_pass(event: InputEvent) -> void: 
	if curr_state != null: curr_state.state_input(event)

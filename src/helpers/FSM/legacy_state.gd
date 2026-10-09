class_name LegacyState
extends Node

@export var transitionable: bool = true
@export var transitions: 	Array[LegacyState]
var transitions_dict: 		Dictionary[StringName, LegacyState]

var fsm: 		LegacyFSM 	# - LegacyFSM that owns this state.
var context: 	Node 	# - context / object that this state (and LegacyFSM) manipulates.
var parent:		NestedState	# - state that is parent of this state. (if it exists).

signal entered
signal exited

var has_entered: bool = false
var has_exited: bool = false

# - concrete
func setup() -> void: 
	if fsm != null: context = fsm.context
	for t in transitions:
		if t == null: continue
		transitions_dict[t.name.to_lower()] = t
	_setup()
	set_process			(false)
	set_physics_process	(false)

func state_enter() -> void: 
	if has_entered: return
	has_entered = true
	has_exited = false
	_state_enter()
	entered.emit()
func state_exit() -> void:
	if has_exited: return
	has_exited = true
	has_entered = false
	_state_exit()
	exited.emit()
	
func state_physics_update(_delta: float) -> void: _state_physics_update(_delta)
func state_update(_delta: float) -> void: _state_update(_delta)
func state_input(_event: InputEvent) -> void: _state_input(_event)
	
# - virtual
func _setup() -> void:	pass
func _state_enter() -> void: pass
func _state_exit() -> void: pass

func _state_physics_update(_delta: float) -> void: pass
func _state_update(_delta: float) -> void: pass
func _state_input(_event: InputEvent) -> void: pass

func can_transition_to(_state_id: StringName) -> bool:
	if !(_state_id in transitions_dict): return false 
	var state = transitions_dict[_state_id]
	
	if state == null: return false
	if state.transitionable and (state.fsm == self.fsm):
		# - this to ensure that the states fsm are from the same state machine
		if state in transitions: return true #  - if this new state is in the current's transitions array...

	return false
func request_transition_to(_state_id: StringName, _force_fsm_priority: bool = false) -> void: 
	if can_transition_to(_state_id):
		if !is_sub_state() or _force_fsm_priority: 
			if fsm.curr_state == self: fsm.change_to_state(_state_id)
		else:				
			if parent.active == self: parent.set_sub_state(_state_id)
func request_transition(_from: StringName, _to: StringName, _force_fsm_priority: bool = false) -> void:
	if !(_from in transitions_dict): 
		if _from == self.name.to_lower(): 
			request_transition_to(_to, _force_fsm_priority)
		return
	
	transitions_dict[_from].request_transition_to(_to, _force_fsm_priority)
	
func is_sub_state() -> bool:
	return parent != null

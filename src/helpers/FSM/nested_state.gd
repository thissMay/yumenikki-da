class_name NestedState
extends LegacyState

var sub_states: Dictionary[StringName, LegacyState]
var active: LegacyState

func _setup() -> void: 
	for states in self.get_children():
		if states is LegacyState:
			states.fsm = fsm
			states.parent = self
			sub_states[states.name.to_lower()] = states 
			states.setup()

	_setup_sub_state()
	
func has_sub(_state_id: StringName) -> bool:
	return sub_states.has(_state_id.to_lower())

func _state_enter() -> void: 
	_enter_sub_state()
	if  active != null: 
		active.state_enter()
func _state_exit() -> void: 
	_exit_sub_state()
	if  active != null: 
		active.state_exit()

func _state_physics_update(_delta: float) -> void: 
	_physics_update_sub_state(_delta)
	if  active != null:
		active.state_physics_update(_delta)
func _state_update(_delta: float) -> void: 
	_update_sub_state(_delta)
	if  active != null:
		active.state_update(_delta)

func _state_input(_event: InputEvent) -> void:
	_input_sub_state(_event)
	if  active != null:
		active.state_input(_event)

# - virtual methods for THIS. its confusing but fuck off.	
func _setup_sub_state() -> void: pass

func _enter_sub_state() -> void: pass
func _exit_sub_state() -> void: pass

func _physics_update_sub_state(_delta: float) -> void: pass
func _update_sub_state(_delta: float) -> void: pass

func _input_sub_state(_event: InputEvent) -> void: pass

# - internal
func set_sub_state(_state_id: StringName) -> void:
	if fsm.curr_state != self: return
	
	_state_id = _state_id.to_lower()
	
	if !has_sub(_state_id): 
		active = null
		return
		
	# if same id, bail.
	if active == sub_states[_state_id]: 
		return
	
	if active != null: active.state_exit() 		# - previous state
	active = sub_states.get(_state_id)	# - new state
	active.state_enter()							

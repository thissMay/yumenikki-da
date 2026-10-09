class_name SBComponent
extends Component

var actor: Actor2D

func _ready() -> void:
	set_process			(false)
	set_physics_process	(false)
	set_process_input	(false)
	
	var sb_component_receiver = get_parent()
	if !sb_component_receiver is SBComponentReceiver: return
	
	Utils.connect_to_signal(_on_bypass_enabled, sb_component_receiver.bypass_enabled)
	Utils.connect_to_signal(_on_bypass_lifted, sb_component_receiver.bypass_lifted)

# -- virtual
func _setup(_sb: Actor2D = null) -> void: actor = _sb

func _update(_delta: float) -> void: pass
func _physics_update(_delta: float) -> void: pass
func _input_pass(_event: InputEvent) -> void: pass

func _on_bypass_enabled() -> void: pass
func _on_bypass_lifted() -> void: pass

# -- concrete, leave alone.
func update(_delta: float) -> void:
	if active: _update(_delta)
func physics_update(_delta: float) -> void:
	if active: _physics_update(_delta)
func input_pass(_event: InputEvent) -> void:
	if active: _input_pass(_event)

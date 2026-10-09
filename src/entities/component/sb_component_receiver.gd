@tool

class_name SBComponentReceiver
extends ComponentReceiver

var actor: Actor2D

func _init(_affector: Node = null) -> void: 
	super(_affector)

func _validate_property(property: Dictionary) -> void:
	if property.name in ["affector", "independent"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
func _ready() -> void:
	if get_parent() != null and get_parent() is Actor2D:
		self.name = "sb_components"
func _setup(_sb: Actor2D = null) -> void: 
	components = self.get_children()
	
	for component in components: 
		if component and component is SBComponent and component.active: 
			component.actor = _sb
			component._setup(_sb)

# ---
func _process(_delta: float) -> void: pass
func _physics_process(_delta: float) -> void: pass
# --- 
func _update(_delta: float) -> void:
	if !bypass:
		for component in components: 
			if component != null and component.active: component.update(_delta)
func _physics_update(_delta: float) -> void: 
	if !bypass:
		for component in components: 
			if component: component.physics_update(_delta)
func _input_pass(_event: InputEvent) -> void:
	if !bypass:
		for component in components: 
			if component: component.input_pass(_event)

func get_component_by_name(_name: String) -> SBComponent:
	for i in get_children():
		if i and i.name == _name:
			return i
			
	return null
func has_component_by_name(_name: String) -> bool:
	for i in get_children():
		if i and i.name == _name: return true
	return false

func set_bypass(_bypass: bool) -> void: 
	bypass = _bypass
	if _bypass: bypass_enabled.emit()
	else: 		bypass_lifted.emit()
	
# - 

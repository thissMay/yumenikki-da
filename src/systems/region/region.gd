@tool

class_name AreaRegion
extends Area2D

@export var rect: CollisionShape2D
@export var debug_colour: Color = Color(0, 0, 0, .3):
	set(_colour):
		if Engine.is_editor_hint():
			debug_colour = _colour
			if rect: rect.debug_color = _colour

var region_priority: int = 0

signal player_enter()
signal player_exit()

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	set_collision_layer_value	(1, false)
	set_collision_mask_value	(1, false)

	rect = Utils.get_child_node_or_null(self, "rect")
	
	if 	rect == null: 
		rect = await Utils.add_child_node(self, CollisionShape2D.new(), "rect")
		rect.shape = RectangleShape2D.new()
		rect.shape.size = Vector2(16, 16)	
		rect.debug_color = Color(0.2 ,0, 0.7, 0.2)
		
	Utils.connect_to_signal(handle_player_enter, 				self.area_entered, CONNECT_DEFERRED)
	Utils.connect_to_signal(handle_player_exit, 				self.area_exited)
	Utils.connect_to_signal(__disable_collision_if_invisible, 	self.visibility_changed)
	
	_setup()

func __disable_collision_if_invisible() -> void:
	rect.disabled = !(self.visible and is_visible_in_tree())

func _setup() -> 				void: 	set_collision_mask_value	(31, true)
func _handle_player_enter() -> 	void: pass
func _handle_player_exit() -> 	void: pass

func handle_player_enter(_pl: Area2D) -> void:
	if _pl.get_parent() != null and _pl.get_parent() is Player2D:
		_handle_player_enter()
		player_enter.emit()
func handle_player_exit(_pl: Area2D) -> void:
	if _pl.get_parent() != null and _pl.get_parent() is Player2D:
		_handle_player_exit()
		player_exit.emit()

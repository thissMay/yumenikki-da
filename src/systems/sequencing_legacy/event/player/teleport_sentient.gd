@tool

class_name EVN_TeleportSentient
extends Event

@export var displace: bool = false
@export var dis_vector: Vector2i = Vector2i.ZERO:
	get: return marker_B.global_position - marker_A.global_position

@export_group("Properties.")
@export var actor: Actor2D
@export var heading: Actor2D.compass_headings = Actor2D.compass_headings.SOUTH
@export var change_heading: bool = false

@export var marker_A: 	Marker2D
@export var marker_B: 	Marker2D

func _ready() -> void:
	marker_A 	= Utils.get_child_node_or_null(self, "marker_A")
	marker_B 	= Utils.get_child_node_or_null(self, "marker_B")
	
	if marker_A == null: marker_A = Utils.add_child_node(self, Marker2D.new(), "marker_A")
	if marker_B == null: marker_B = Utils.add_child_node(self, Marker2D.new(), "marker_B")
	
	if Engine.is_editor_hint(): 
		process_mode = Node.PROCESS_MODE_PAUSABLE
		Utils.connect_to_signal(_draw_marker_A, marker_A.draw)
		Utils.connect_to_signal(_draw_marker_B, marker_B.draw)
	else:
		process_mode = Node.PROCESS_MODE_DISABLED
		Utils.disconnect_from_signal(_draw_marker_B, marker_B.draw)
		Utils.disconnect_from_signal(_draw_marker_A, marker_A.draw)
# --- draw ---
func _draw_marker_A() -> void: 
	if Engine.is_editor_hint(): 
		marker_A.draw_line(Vector2.ZERO, marker_B.global_position - marker_A.global_position, Color.RED)
func _draw_marker_B() -> void:
	if Engine.is_editor_hint(): 
		marker_B.draw_texture(
			SpawnPoint.TEXTURE, 
			-SpawnPoint.TEXTURE.get_size() / 2 - Vector2(0, 8), Color(0.414, 0.373, 0.717, 0.35))

func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): 
		marker_A.	queue_redraw()
		marker_B.	queue_redraw()
# ---
	
func _execute	() -> void:
	match displace:
		true: 	actor.global_position += Vector2(dis_vector)
		_:		actor.global_position = marker_B.global_position
	
	if change_heading: 		actor.heading = heading
func _validate() -> bool: 
	return actor != null

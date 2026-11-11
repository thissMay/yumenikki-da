@tool

class_name EVN_GoToPoint
extends Event

@export var actor: Actor2D
@export var marker: Marker2D
@export var point: SpawnPoint

func _ready() -> void:
	marker = Utils.get_child_node_or_null(self, "marker")
	if marker == null: marker = Utils.add_child_node(self, Marker2D.new(), "marker")
	super()

func _execute() -> void:
	actor.global_position = point.global_position
func _validate() -> bool:
	if point == null or actor == null:
		printerr("EVENT - TRAVEL POINT :: Spawn Point or Sentient is not found!")
		return false
	return true

@tool

class_name ConditionalEvent
extends Event

@export var if_true: 	Sequence
@export var if_false: 	Sequence

func _ready() -> void:
	super()
	
	if 	if_true == null:
		if_true = Utils.add_child_node(self, Sequence.new(), "if_true")
		if_true.custom_linked_pointers = true
	
	if 	if_false == null:
		if_false = Utils.add_child_node(self, Sequence.new(), "if_false")
		if_false.custom_linked_pointers = true

func _predicate() -> bool:
	return true

func _execute	() -> void:
	var prioritize_seq: Sequence = null
	
	if _predicate(): 	prioritize_seq = if_true
	else: 				prioritize_seq = if_false
	
	prioritize_seq.execute()
	await prioritize_seq.finished
		
func _validate() -> bool:
	return if_true != null and if_false != null

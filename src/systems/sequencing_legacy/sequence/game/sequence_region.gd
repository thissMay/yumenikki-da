@tool

class_name SequenceRegion
extends Node

@export var enter_sequence: Sequence
@export var exit_sequence: Sequence

func _init() -> void:
	self.name = "sequence_region"
func _ready() -> void:
	var area_region = get_parent()
	
	enter_sequence = Utils.get_child_node_or_null(self, "enter")
	exit_sequence = Utils.get_child_node_or_null(self, "exit")
	
	if enter_sequence == null: enter_sequence = Utils.add_child_node(self, Sequence.new(), "enter")
	if exit_sequence == null: exit_sequence = Utils.add_child_node(self, Sequence.new(), "exit")
	
	if area_region != null and area_region is AreaRegion:
		Utils.connect_to_signal(__execute_enter, (area_region as AreaRegion).player_enter)
		Utils.connect_to_signal(__execute_exit, (area_region as AreaRegion).player_exit)

func __execute_enter() -> void:  	if enter_sequence != null: enter_sequence.execute()
func __execute_exit() -> void:  	if exit_sequence != null: exit_sequence.execute()

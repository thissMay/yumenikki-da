@tool

class_name Event2D
extends Node2D

func _ready() -> void:
	set_script(load("res://src/systems/sequencing/event_interface.gd"))

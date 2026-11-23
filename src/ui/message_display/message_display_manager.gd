@tool

class_name MessageDisplayManager
extends Control

static var instance: MessageDisplayManager

var is_open: bool = false
var active: MessageDisplay

var current_index: int = 0
var texts: PackedStringArray

func _ready() -> void:
	instance = self
	

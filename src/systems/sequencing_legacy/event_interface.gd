@tool
class_name Event 
extends Node

signal finished
signal cancelled

const BASE_SCRIPT := preload("res://src/systems/sequencing_legacy/event_interface.gd")

# template pusherr line:
# printerr("EVENT - {NAME} :: {WARNING}!")

# --
@export_category("Event Flags.")
@export var wait_til_finished: 	bool = true
@export var skip: 				bool = false
@export var call_limit: int = 0 # - inclusive.

var call_count: int = 0
@export_category("Event Linked-Pointers.")
@export var custom_linked_pointers: bool = false
@export var prev: Node:
	set(_p): if _p != self: prev = _p
@export var next: Node:
	set(_n): if _n != self: next = _n

var is_finished: bool = false
var is_active: bool = false

# - unfortunately not all events are allowed to skip their warnings as most 
# of em are really needed at some scenarios.

# -- initial
func _ready() -> void: 
	process_mode = Node.PROCESS_MODE_DISABLED

# -- virtual, override these.
func _execute	() -> void: pass
func _cancel	() -> void: pass
func _end		() -> void: pass
func _validate() -> bool: return true

# -- concrete implementations
func execute() -> void: 	
	is_finished = false
	is_active = true
	
	if call_limit > 0:
		call_count += 1
		
		# - first event call will have the "call_count" SET TO 1, NOT TO 0.
		if call_count > call_limit: 
			__call_finished.call_deferred()
			is_finished = true
			is_active = false
			return
		
	if wait_til_finished: await _execute()
	else:						_execute()
		
	__call_finished.call_deferred()
	
	is_finished = true
	is_active = false
	
func cancel() -> void:
	_cancel()
	is_active = false
	is_finished = true
	__call_canceled.call_deferred()
func end() -> void: 
	_end()
	is_active 	= false
	is_finished = true

# -- internal
func __call_finished() -> void: if is_inside_tree(): finished.emit()
func __call_canceled() -> void: if is_inside_tree(): cancelled.emit()

func has_next() -> bool: return next != null
func has_prev() -> bool: return prev != null

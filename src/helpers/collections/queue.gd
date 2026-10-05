class_name Queue
extends RefCounted

signal pushed(_element: Variant)
signal popped(_element: Variant)

## Array holding the queue content.
var tail: Variant
var head: Variant
var array: Array = []

var uncapped: bool = true
var max_size: int = 0

func _init(_max_size: int = 0, _uncapped: bool = true) -> void: 
	max_size = _max_size
	uncapped = _uncapped

## Returns the head element without removing it.
func peek_head() -> Variant:
	if array.is_empty(): return null
	return array[array.size() - 1]

func peek_tail() -> Variant:
	if array.is_empty(): return null
	return array[0]
	
func enqueue(_element: Variant) -> void: 
	array.push_front(_element)
func dequeue() -> Variant: 
	if array.is_empty(): return null
	return array.pop_back()
	

class_name Stack
extends RefCounted

signal pushed(_element: Variant)
signal popped(_element: Variant)

## Array holding the stack content.
var top: Variant
var array: Array = []

var uncapped: bool = true
var max_size: int = 0

func _init(_max_size: int = 0, _uncapped: bool = true) -> void: 
	max_size = _max_size
	uncapped = _uncapped

## Returns the top element without removing it.
func peek() -> Variant:
	if array.is_empty(): return null
	return array[array.size() - 1]

## Returns and removes the top element of the stack.
func queue_pop() -> void:
	var to_be_popped = null
	if array.size() > 0:
		to_be_popped = array.back()
		if to_be_popped is StackNode: await to_be_popped._on_pre_pop()

func pop() -> Variant: 
	var popped_value = null
	if array.size() > 0:
		popped_value = array.pop_back()
		if popped_value is StackNode: popped_value._on_pop()
		if array.size() > 0: 	top = array.back()
		else: 					top = null
		popped.emit(popped_value)
	
	return popped_value

## Pushes a new element onto the stack, essentially becoming the new top.
func push(_element: Variant) -> void:
	# - we ignore max_size limits if (max_size <= 0)
	
	if max_size > 0 and array.size() > max_size: 
		if !uncapped: return
		 
	array.append(_element)
	top = _element
	if _element is StackNode: 
		_element._on_push()
	pushed.emit(_element)

## Checks whether the stack is empty or not.
func is_empty() -> bool:
	return array.is_empty()

func _to_string() -> String:
	return str("stak", " -- TOP : %s, STACK : %s " % [top, array])

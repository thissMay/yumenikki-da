# unordered sets.

class_name Set
extends RefCounted

# iteration stuff
var index: 	int = 0
var end: 	int = 0
var start: 	int = 0

## Array holding the set content.
var array: Array = []

## Returns the head item without removing it.
func _init(... args: Array[Variant]) -> void:
	if !args.is_empty():
		for i in args: add(i)

func item_at(idx: int) -> Variant:
	return array.get(idx)

func index_of(item: Variant) -> int:
	return array.find(item)

func add(item: Variant) -> bool:
	if (!array.has(item)): 
		array.append(item)
		return true # if item was added for the first time, return true.
	return false # if item already exists, return false.
	
func remove(item: Variant) -> void:
	if (array.has(item)):
		array.remove_at(index_of(item))

func contains(item: Variant) -> bool:
	return array.has(item)
	
# -- to string stuff.
func _to_string() -> String:
	return str("id: %s - %s " % [self.get_instance_id(), array])


# -- iterator -- 
func _iter_init(iter: Array) -> bool:
	start = 0
	end = array.size()
	return can_iterate()
	
func _iter_next(iter: Array) -> bool:
	index += 1
	return can_iterate()
	
func _iter_get(iter: Variant) -> Variant:
	return array[index]

func can_iterate() -> bool:
	return index < end

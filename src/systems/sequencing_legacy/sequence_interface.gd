@tool

class_name Sequence 
extends Event

var priority: int = 0

@export var order: Array[Node]
var marked_invalid: PackedInt32Array
var bail_requested: 				bool = false

@export_tool_button("Re-initialize Sequence Order") 		var reinitialize: 		Callable = initialize
@export_tool_button("Let all (children) events wait.") 		var let_events_wait: 	Callable = let_children_await
@export_tool_button("Let all (children) events instant.") 	var let_events_instant: Callable = let_children_instant
@export_group("Sequence Flags.")

@export var skip_invalid_events: 	bool = false
@export var async: 					bool = false

@export var front: Node
@export var back:  Node

var curr: Event

# - signals
signal success
signal fail

func initialize() -> void:
	order = get_children()	
	if order.is_empty(): 
		front = null
		back = null
		return
	
	front = order[0]
	back = order[order.size() - 1]
	
	for e in order:
		if 	e != null and e is Event:
			if !e.custom_linked_pointers:
				e.next = null
				e.prev = null

	for i: int in range(order.size()):
		var j := i + 1
		var _curr: 	Event = order[i]
		var _next: 	Event  = null
		
		if j < order.size():
			_next = order[j]
			if !_curr.custom_linked_pointers: _curr.next = _next
			if !_next.custom_linked_pointers: _next.prev = _curr
func _ready() -> void:
	initialize()
	Utils.connect_to_signal(initialize, child_order_changed)

func _execute() -> void:
	reset()
	# - if the sequence is not valid, we halt and not run it.
	if !_validate():
		return
	
	# - we iterate thru the events..
	curr = front
	while curr != null:
		# - make sure that the child is of type Event.
		if curr is Event:
			
			if curr.get_instance_id() in marked_invalid or curr.skip: 
				if curr.has_next() and curr != self: curr = curr.next
				else:				break
			
			if !curr.is_active and !curr.is_finished: curr.execute() 
			if !curr.is_finished: 
				await get_tree().process_frame
				continue
			
			curr.end()
		if 	bail_requested: 
			break	
		
		if curr.has_next(): curr = curr.next
		else:				break
		
	curr = null
	end()
	
func _cancel() -> void:
	bail_requested = true
func _end() -> void: 
	if 	bail_requested: 
		bail_requested = false
		__call_canceled.call_deferred()
			
func _validate() -> bool:
	# - we are going to validate that every single event is happy and satisifed:
	# checking for any missing dependencies, has the corect properties, etc.
	var event = front
	while event != null:
		if event.skip: 
				if event.has_next(): event = event.next
				else:				break 
		if event == null or !event._validate():
			# - if event is invalid...
			if skip_invalid_events: marked_invalid.append(event.get_instance_id()) # - we mark invalid events to be skipped.
			else:
				fail.emit()
				printerr("SEQUENCE %s :: Sequence halted. Event error: %s!" % [self.name, event.name])
				return false # - we halt the sequence if the sequence if we won't skip any invalid events.

		if event.has_next(): event = event.next
		else:				break
	
	success.emit()	
	return true
func reset() -> void: 
	var curr = front
	
	while curr != null:
		# - make sure that the child is of type Event.
		if curr is Event:
			if !curr.is_active: 
				curr.is_finished 	= false
				curr.is_active 		= false
			
			if curr.has_next(): curr = curr.next
			else:				break
# -- 

func let_children_await() -> void: 
	for i: Event in order:
		if i != null: i.wait_til_finished = true
func let_children_instant() -> void:
	for i: Event in order:
		if i != null: i.wait_til_finished = false

# -- 
func append(_event: Event, _id_name: String, _wait_til_finished: bool = true) -> void: 
	Utils.add_child_node(self, _event, _id_name)
	_event.wait_til_finished = _wait_til_finished
	order.append(_event)

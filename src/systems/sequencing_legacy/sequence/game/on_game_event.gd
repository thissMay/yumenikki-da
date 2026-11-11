@tool
 
class_name OnGameEvent
extends Sequence

@export var event_id: Array[String]
@export var sequence: Sequence
var listener: EventListener

func _ready() -> void: 
	super()
	if Engine.is_editor_hint(): return
	listener = EventListener.new(self)
	
	for i in event_id:
		listener.listen_to_event(i)
		listener.do_on_notify(execute, i)

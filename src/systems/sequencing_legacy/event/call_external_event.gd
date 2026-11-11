class_name EVN_CallExternal
extends Event

@export var event: Event

func _execute() -> void:
	event.execute()
	await event.finished
	
func _validate() -> bool:
	return event != null and event is Event

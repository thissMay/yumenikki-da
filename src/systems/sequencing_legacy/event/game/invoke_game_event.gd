class_name EVN_InvokeGlobalEvent
extends Event

@export var event_id: String
@export var params: Array[Variant]

func _init(_id: String = "", ..._params: Array[Variant]) -> void:
	event_id = _id
	params = _params

func _execute() -> void: 
	EventManager.invoke_event(event_id, params)

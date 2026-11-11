class_name EVN_PLAppendEffect
extends Event

@export var effect: PLEffect
@export var flash: bool = true

func _execute() -> void:
	EventManager.invoke_event("PLAYER_EFFECT_FOUND", effect, flash)

func _validate() -> bool:
	return effect != null

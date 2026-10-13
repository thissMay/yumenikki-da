extends ConditionalEvent
@export var current_effect_is: PLEffect

func _predicate() -> bool:
	return PlayerInstance.instance.components.get_component_by_name("equip_manager").effect_data == current_effect_is

extends PLAction

func _perform		(_pl: Player) -> void:
	if _pl.components.get_component_by_name(Player2D.Components.EQUIP).effect_data == null: return
	_pl.components.get_component_by_name(Player2D.Components.EQUIP).effect_data._primary_action(_pl)

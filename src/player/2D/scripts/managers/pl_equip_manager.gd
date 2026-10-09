class_name PlEquipManager
extends SBComponent

const IGNORE = [Player.Instance.DEFAULT_EQUIPMENT]

var equipped: bool:
	get: return effect_data != null and !effect_data in IGNORE
var behaviour: PLBehaviour:
	get:
		if effect_data == null: return Player.Instance.DEFAULT_EQUIPMENT.behaviour
		return effect_data.behaviour

var effect_prefab: 	PLEffectComponent 	= null
var effect_data: 	PLEffect 			= null
var effect_values: 	PLVariables 		= null:
	get:
		if effect_data != null:   	return effect_data.variables
		else: 						return effect_values
		

func _setup(_sb: Actor2D = null) -> void:
	equip(_sb, Player.Instance.equipment_pending, true)

# ----> equip / de-equip.
func equip(_pl: Player, _effect: PLEffect, _skip: bool = false) -> void:
	if _effect == null or _effect == effect_data: return
	if _effect:
		_pl.components.get_component_by_name(Player_YN.Components.ACTION).cancel_action(_pl, true)
			
		deequip(_pl)
		effect_data = _effect
		
		_pl.sprite_sheet = load(_effect.variables.sprite_override)

		EventManager.invoke_event("PLAYER_EQUIP_SKIP_ANIM", _effect.skip_equip_animation or _skip)
		EventManager.invoke_event("PLAYER_EQUIP", _effect)
		Player.Instance.equipment_pending = _effect
		
		_effect._apply(_pl)
func deequip(_pl: Player, _skip: bool = false) -> void:
	if effect_data and !(effect_data in IGNORE):
		EventManager.invoke_event("PLAYER_DEEQUIP_SKIP_ANIM", effect_data.skip_deequip_animation or _skip)
		EventManager.invoke_event("PLAYER_DEEQUIP", Player.Instance.DEFAULT_EQUIPMENT)
		Player.Instance.equipment_pending = Player.Instance.DEFAULT_EQUIPMENT
		

		if effect_prefab != null: 
			effect_prefab._exit(_pl)
			effect_prefab.queue_free()

		effect_data._unapply(_pl)
		effect_data 	= null
		
		_pl.sprite_sheet = load(_pl.values.sprite_override)

func change_effect(_pl: Player, _new_effect: PLEffect, _skip: bool = false) -> void:
	if _new_effect == null: return
	_pl.components.get_component_by_name(Player_YN.Components.ACTION).cancel_action(_pl, true)
	equip(_pl, _new_effect, _skip) 

func _physics_update(_delta: float) -> void:
	if effect_data != null: effect_data._effect_phys_update	(actor, _delta)
func _update(_delta: float) -> void:
	if effect_data != null: effect_data._effect_update		(actor, _delta)
func _input_pass(event: InputEvent) -> void: 
	if effect_data != null: effect_data._effect_input		(actor, event)
		
	if Input.is_action_just_pressed("ui_favourite_effect"): 
		if !equipped: 	
			change_effect(actor, Player.Instance.equipment_favourite)
		else:	
			actor.components.get_component_by_name(Player_YN.Components.ACTION).cancel_action(actor, true)		
			deequip(actor)

class_name PLInventory
extends Control

@export var fsm: SM
@export var display: Control
@export var item_container: GridContainer

@export var favourite_icon: Sprite2D

var hovered_button: GUIPanelButton
var effects: Array[PLEffect]
var effect_buttons: Array[GUIPanelButton]

# - initializaiton (called from special invert state).
func _setup() -> void:
	fsm._setup(self)
		
func _enter() -> void: 
	(self.visible) = true
	fsm.curr_state._state_enter()
func _exit() -> void: 
	(self.visible) = false
	fsm.curr_state._state_exit()

# - adding + removing items.
func delete_buttons() -> void: 
	effects.clear()
	for i in item_container.get_children():
		i.queue_free()
func add_item(_item: PLEffect) -> void: 
	if _item == null or _item in effects: return
	effects.append(_item)
	var button = GUIPanelButton.new()
	effect_buttons.append(button)
	
	item_container.add_child(button)
	button.custom_minimum_size = Vector2(75, 20)
	
	button.text_display.text = (_item.name)
	button.icon_display.texture = (_item.icon)
	
	button.name = (_item.name)
	button.focus_entered.	connect(func(): hovered_button = button)	
	button.focus_exited.	connect(func(): hovered_button = null)
	button.pressed.			connect(func():
		select_at_idx(effect_buttons.find(button)))
func remove_item(_item: PLEffect) -> void:
	var item_idx := effects.find(_item)
	if item_idx > 0: effects.remove_at(0)
	
	for i in effect_buttons:
		if i.abstract_button.unique_data == _item: i.queue_free()
	
func get_at_idx(_idx: int = 0) -> PLEffect:
	if _idx < effects.size():
		if effects[_idx] != null: return effects[_idx] 
	return null
	
func select_at_idx(_idx: int = 0, _leave_menu: bool = true) -> void: 
	if _idx < effects.size():
		if effects[_idx] != null:
			if _leave_menu: EventManager.invoke_event("SPECIAL_INVERT_END_REQUEST")
			Player.Instance.get_pl().components.get_component_by_name(Player_YN.Components.EQUIP).change_effect(
				Player.Instance.get_pl(), 
				effects[_idx])
				
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_favourite_effect"):
		if hovered_button != null:  
			Player.Instance.equipment_favourite = get_at_idx(effect_buttons.find(hovered_button))
			favourite_icon.global_position = hovered_button.global_position

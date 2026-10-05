extends LegacyState

@export var path_follow_cam: PathFollow2D
@export var path_follow_ui: PathFollow2D
@export var to_save_button: AbstractButton
@export var save_buttons: Array[GUIPanelButton]

@export var prompt_yes: GUIPanelButton
@export var prompt_no: GUIPanelButton
@export var prompt: Control

var tween: Tween
var pending_save_id: int = 0

func _state_enter() -> void:
	prompt.get_node("prompt").text_display.text = "Are you sure you want to save in this slot?"
	
	for save in save_buttons: 
		Utils.connect_to_signal(_save.bind(int(save.name)), save.pressed)
	
	to_save_button.set_active(false)
	
	if tween != null: tween.kill()
	tween = self.create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel()
	tween.tween_property(path_follow_cam, "progress_ratio", 0, 2)
	tween.tween_property(path_follow_ui, "progress_ratio", 0, 2)

func _state_exit() -> void:
	for save in save_buttons:
		Utils.disconnect_from_signal(_save.bind(int(save.name)), save.pressed)

	to_save_button.set_active(true)

	
func _save(_slot: int = 0) -> void: 
	var save_slot = save_buttons[_slot - 1] if _slot > 0 else null
	var save := func():
		Save.save_data(_slot)
		save_slot.abstract_button.unique_data = Save.get_data_as_json("save_%s" % [_slot])
			
	if  save_slot != null:
		
		if save_slot.abstract_button.unique_data == null: save.call()
		else:
			prompt.visible = true
			Utils.connect_to_signal(save.call, prompt_yes.pressed, Object.CONNECT_ONE_SHOT)
			

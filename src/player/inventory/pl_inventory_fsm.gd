extends SM

var player_equip_listener: EventListener
var special_invert_sequence_end: EventListener

@export var white_petal: Control
@export var pink_petal: Control

@export var white_petal_button: GUITextureButton
@export var pink_petal_button: GUITextureButton

@export var deequip_prompt: GUITextureButton
@export var effect_indicator: SpriteSheetFormatter

var petal_tween: Tween
const DEFAULT_DATA: PLInventoryData = preload("res://src/player/inventory/data/empty.tres")

func _setup(_owner: Node, _skip_initial_state_setup: bool = false) -> void:
	super(_owner)
	
	white_petal.visible = false
	pink_petal.visible = false
	
	special_invert_sequence_end = EventListener.new(self, "SCENE_CHANGE_REQUEST", "PLAYER_EQUIP", "PLAYER_DEEQUIP")
	special_invert_sequence_end.do_on_notify( 
		EventManager.invoke_event.bind("SPECIAL_INVERT_END_REQUEST"),
		"SCENE_CHANGE_REQUEST", "PLAYER_EQUIP", "PLAYER_DEEQUIP")
	
	player_equip_listener = EventListener.new(self, "PLAYER_EQUIP", "PLAYER_DEEQUIP")
	player_equip_listener.do_on_notify(
		func(): 
			deequip_prompt.button.set_active(false)
			effect_indicator.progress = 1,
		"PLAYER_DEEQUIP")
	player_equip_listener.do_on_notify( 
		func(): 
			if EventManager.get_event_param("PLAYER_EQUIP")[0] == Player.Instance.DEFAULT_EQUIPMENT: 
				return
			deequip_prompt.button.set_active(true)
			effect_indicator.progress = 0,
		"PLAYER_EQUIP")
	
	Utils.connect_to_signal(func():(Player.Instance.get_pl() as Player_YN).deequip_effect(), deequip_prompt.button.pressed)
	Utils.connect_to_signal(func(): change_to_state("white_petal"), white_petal_button.button.pressed)
	Utils.connect_to_signal(func(): change_to_state("pink_petal"), pink_petal_button.button.pressed)

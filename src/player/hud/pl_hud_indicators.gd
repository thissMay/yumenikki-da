extends Control

@export var effect_ind: SpriteSheetFormatter
var effect_equip: EventListener

func _ready() -> void:
	
	effect_equip = EventListener.new(self, "PLAYER_EQUIP", "PLAYER_DEEQUIP")

	effect_equip.do_on_notify(func(): effect_ind.progress = 0, "PLAYER_DEEQUIP")
	


		

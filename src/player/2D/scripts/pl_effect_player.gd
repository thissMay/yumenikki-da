extends Node2D

@export var animation_player: AnimationPlayer
var on_player_effect: EventListener
var flash_tween: Tween

func _ready() -> void:
	on_player_effect = EventListener.new(self, "PLAYER_EQUIP", "PLAYER_DEEQUIP", "PLAYER_EFFECT_FOUND")
	
	on_player_effect.do_on_notify(
		func():
			if EventManager.get_event_param("PLAYER_EFFECT_FOUND")[1]:
				flash_player_sprite(), "PLAYER_EFFECT_FOUND")
	on_player_effect.do_on_notify( # - Equip
		func():
			if (EventManager.get_event_param("PLAYER_EQUIP_SKIP_ANIM")[0] == true): return
			flash_player_sprite()
			self.global_position = PlayerInstance.instance.global_position
			animation_player.play("effect_equip"), 
		"PLAYER_EQUIP")		
	on_player_effect.do_on_notify( # - Dequip
		func(): 
			if (EventManager.get_event_param("PLAYER_DEEQUIP_SKIP_ANIM")[0] == true): return
			flash_player_sprite()
			self.global_position = PlayerInstance.instance.global_position
			animation_player.play("effect_deequip"),
		"PLAYER_DEEQUIP")
			

func flash_player_sprite() -> void:
	if PlayerInstance.instance != null:
		(PlayerInstance.instance.sprite_renderer.get_node("shader") as ColorRect).color.a = 1
		if flash_tween != null: flash_tween.kill()
		flash_tween = self.create_tween()
		flash_tween.tween_property((PlayerInstance.instance.sprite_renderer.get_node("shader") as ColorRect), "color:a", 0, .5)
			

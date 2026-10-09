class_name ButtonDecorationBar
extends ButtonDecorationComponent

@export var textureRect: TextureRect

func hover_anim() -> void: 
	textureRect.size.x = 0
	
	var t: Tween = self.create_tween()
	t.set_parallel()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_EXPO)
	t.tween_property(textureRect, "size:x", self.size.x, 1)
	
func unhover_anim() -> void: 
	textureRect.size.x = self.size.x
	
	var t: Tween = self.create_tween()
	t.set_parallel()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_EXPO)
	t.tween_property(textureRect, "size:x", 0, 1)
	
func press_anim() -> void: pass

func validate() -> bool:
	return textureRect != null

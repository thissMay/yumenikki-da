extends Event

@export var animator: SpriteSheetFormatterAnimated
@export var animation_sheet: Texture2D
@export var animation_backwards: bool = false
@export_range(1, 100, .01) var animation_speed: float = 1 

func _execute() -> void:
	animator.play(
		animation_sheet, 
		animation_backwards,
		animation_speed)
	if wait_til_finished:
		await animator.animation_finished

func _validate() -> bool:
	if animation_sheet == null:
		printerr("EVENT - PLAY SPRITE ANIMATION :: Animation texture is null!!")
		return false
	return true

		

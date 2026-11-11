@tool

class_name SpriteSheetFormatterAnimated
extends SpriteSheetFormatter

@export_category("Spritesheet Animation")

# ---- animation flags ----
@export_group("Play Properties")
var playing: bool = false
@export var autoplay: bool = false:
	set(_auto):
		autoplay = _auto
		if Engine.is_editor_hint(): playing = _auto
@export var loop: bool = false

@export var reverse: bool = false
@export var end_frame: bool = false

var reached_end: bool = false
var reached_first: bool = false

# ---- time ----
@export_group("Animation Properties")
@export var progress_offset: int = 0
@export var fps: float = 1

@export_subgroup("Randomness")
@export_subgroup("Randomness/FPS")
@export var random_fps_range: bool = false
@export var fps_min: float = 0 
@export var fps_max: float = 1 

@export_subgroup("Randomness/Offset")
@export var random_offset_range: bool = false
@export var offset_min: int = 0:
	set(_val):
		if (_val) < frame_h_count - (frame_h_count - offset_max): offset_min = _val
@export var offset_max: int = 0:
	set(_val):
		if (_val) < frame_h_count: offset_max = _val

var time_elapsed: float = 0

# ---- signals ----s
signal animation_loop
signal animation_finished

func _ready() -> void:
	super()
	
	if (random_fps_range):
		fps = randf_range(fps_min, fps_max)
		
	if autoplay: play(texture)
	if !playing: set_physics_process(false) 
	animation_loop.connect(func(): if !loop: playing = false)
	
func play(
	_sprite: Texture2D, 
	_reverse: bool = false) -> void:
		set_physics_process(true)
		set_sprite(_sprite)
		playing = true

		progress = 0 + progress_offset if !_reverse else frame_h_count - 1 - progress_offset
		reverse = _reverse
	
func _physics_process(delta: float) -> void:
	if playing:
		time_elapsed += delta
		
		if (time_elapsed > 1 / fps):
			progress = progress + 1 if !reverse else progress - 1
			time_elapsed = 0
						
			if progress == 0: 
				if end_frame: progress = 0 if reverse else frame_h_count - 1 
				animation_loop.emit()
				animation_finished.emit()
				
			reached_end = progress == frame_h_count - 1
			reached_first = progress == 0

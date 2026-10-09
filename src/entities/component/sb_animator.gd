class_name SentientAnimator
extends SBComponent

var can_play: bool = true

signal finished

# --- components ---
var animation_player: AnimationPlayer
var sprite_renderer: Sprite2D
var loop_type: Animation.LoopMode:
	get:
		if !animation_player.current_animation.is_empty() and \
			animation_player.get_animation(animation_player.current_animation) != null:
			
			return animation_player.get_animation(animation_player.current_animation).loop_mode
		
		return Animation.LoopMode.LOOP_NONE
		
# --- gimmicks ---
const DEFAULT_DYNAMIC_ROT_MULTI = 1

var dynamic_rot_intensity: float = 3.85
var dynamic_rot_multi: float = DEFAULT_DYNAMIC_ROT_MULTI

# --- setup functions --- 
func _setup(_sentient: Actor2D = null) -> void:
	super(_sentient)
	animation_player = get_node("animation_player")
	animation_player.animation_finished.connect(finished.emit)
				
func _update(_delta: float) -> void:
	if actor.is_moving: 
		animation_player.speed_scale = clamp(.36 * log(actor.speed / 3.25 + 1), 0, INF)
	else: animation_player.speed_scale = 1
		
# --- handler functions ---
func stop() -> void: animation_player.stop()
func play_animation(_path: String, _speed: float = 1, _backwards: bool = false) -> void:
	if can_play and has_animation(_path): 
		animation_player.play(_path, -1 ,_speed, _backwards)
		await animation_player.animation_finished
func get_animation(_path: String) -> Animation:
	return animation_player.get_animation(_path)
func seek(_seconds: float, _update: bool = false, _update_only: bool = false) -> void:
	animation_player.seek(_seconds, _update, _update_only)
	
func has_animation(_path: String) -> bool:
	return animation_player.has_animation(_path)

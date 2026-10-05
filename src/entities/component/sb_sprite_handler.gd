extends SBComponent

const DEFAULT_DYNAMIC_ROT_MULTI = 1

@export var sprite_renderer: SpriteSheetFormatter

var dynamic_rot_intensity: float = 3.85
var dynamic_rot_multi: float = DEFAULT_DYNAMIC_ROT_MULTI

func _setup(_sentient: SentientBase = null) -> void:
	super(_sentient)
	sprite_renderer.row = sentient.heading
	
func _update(_delta: float) -> void:
	handle_sprite_flip(sentient)
	handle_sprite_subtle_rotation(sentient)		
	handle_sprite_direction(sentient)

func handle_sprite_subtle_rotation(_sentient: SentientBase) -> void:
	sprite_renderer.rotation_degrees = lerp(
		sprite_renderer.rotation_degrees, 
		abs((_sentient.velocity.x / _sentient.BASE_SPEED) * dynamic_rot_intensity * dynamic_rot_multi),
		(get_process_delta_time()) / _sentient.TRANS_WEIGHT)
func handle_sprite_flip(_sentient: SentientBase) -> void:
	if _sentient.direction.x < 0: 	sprite_renderer.scale.x = -1
	elif _sentient.direction.x > 0: sprite_renderer.scale.x = 1
func handle_sprite_direction(_sentient: SentientBase) -> void:
	if sentient.is_moving: 	lerp_spr_dir(_sentient, _sentient.heading)
	else: 					set_spr_dir(_sentient, _sentient.heading)

func lerp_spr_dir(_sentient: SentientBase, _heading: SentientBase.compass_headings) -> void:
	sprite_renderer.row = (lerpf(sprite_renderer.row, _heading, _sentient.TRANS_WEIGHT))

# sprite 
func set_spr_dir(_sentient: SentientBase, _heading: SentientBase.compass_headings) -> void: 
	sprite_renderer.row = _heading
func set_dynamic_rot_multi(_multi: float) -> void:
	dynamic_rot_multi = _multi

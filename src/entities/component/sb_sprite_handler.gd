class_name ImmersiveSpriteComponent
extends SBComponent

const DEFAULT_DYNAMIC_ROT_MULTI = 1

@export var sprite_renderer: SpriteSheetFormatter

var dynamic_rot_intensity: float = 3.85
var dynamic_rot_multi: float = DEFAULT_DYNAMIC_ROT_MULTI

func _setup(_sentient: Actor2D = null) -> void:
	super(_sentient)
	sprite_renderer.row = (actor.direction.dot(Vector2.DOWN) + 1) * 5
	
func _update(_delta: float) -> void:
	handle_sprite_flip(actor)
	handle_sprite_subtle_rotation(actor)		
	handle_sprite_direction(actor)

func handle_sprite_subtle_rotation(_sentient: Actor2D) -> void:
	sprite_renderer.rotation_degrees = lerp(
		sprite_renderer.rotation_degrees, 
		((_sentient.velocity.x / _sentient.BASE_SPEED) * dynamic_rot_intensity * dynamic_rot_multi),
		(get_process_delta_time()) / _sentient.TRANS_WEIGHT)
func handle_sprite_flip(_sentient: Actor2D) -> void:
	if _sentient.direction.x < 0: 	sprite_renderer.scale.x = -1
	elif _sentient.direction.x > 0: sprite_renderer.scale.x = 1
func handle_sprite_direction(_sentient: Actor2D) -> void:
	if actor.is_moving: 	lerp_spr_dir(_sentient)
	else: 					set_spr_dir(_sentient)

func lerp_spr_dir(_sentient: Actor2D) -> void:
	sprite_renderer.row = (lerpf(sprite_renderer.row, (actor.direction.dot(Vector2.DOWN) + 1) * 2.5, _sentient.TRANS_WEIGHT))

# sprite 
func set_spr_dir(_sentient: Actor2D) -> void: 
	sprite_renderer.row = (actor.direction.dot(Vector2.DOWN) + 1) * 2.5
func set_dynamic_rot_multi(_multi: float) -> void:
	dynamic_rot_multi = _multi

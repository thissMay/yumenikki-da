class_name Actor2D
extends CharacterBody2D

@export var values: SBVariables = SBVariables.new():
	get = get_values,
	set = set_values

# - input
signal input_vector(_input: Vector2)
var desired_vel: Vector2
var desired_speed: 			float = 0

var vel_input: Vector2i:
	set(input): 
		vel_input.x = clamp(input.x, -1, 1)
		vel_input.y = clamp(input.y, -1, 1)
var dir_input: Vector2i:
	set(input): 
		dir_input.x = clamp(input.x, -1, 1)
		dir_input.y = clamp(input.y, -1, 1)

var components: SBComponentReceiver
# - consts
const TRANS_WEIGHT:	float = 0.325
const BASE_SPEED: 	float = 27.5
const MAX_SPEED: 	float = 95

const WALK_MULTI: 			float = 1.19
const SNEAK_MULTI: 			float = 0.835
const SPRINT_MULTI: 		float = 2.9

const WALK_NOISE_MULTI: 	float = 1
const SPRINT_NOISE_MULTI: 	float = 2.2
const SNEAK_NOISE_MULTI: 	float = 0.3

# - direction
enum compass_headings {
	NORTH = 0,
	NORTH_HORIZ = 1,
	HORIZ = 2,
	SOUTH_HORIZ = 3,
	SOUTH = 4}
@export var heading: compass_headings = compass_headings.SOUTH

var direction: Vector2 = Vector2(0, 1):
	set(dir): 
		direction.x = clamp(dir.x, -1, 1)
		direction.y = clamp(dir.y, -1, 1)
var lerped_direction: Vector2 = Vector2.DOWN

# - mobility
var speed: 				float = 0: 
	get: return self.velocity.length()
var real_speed:
	get: return self.get_real_velocity().length();
	
var speed_multiplier: 	float = 1

# - noise
var noise: 			float = 0:
	get: return (self.speed / self.MAX_SPEED) * noise_multi
var noise_multi: 	float = 1

# - flags
var is_moving: 		bool = false:
	get: return speed > 0

# - initial.
func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	components = $sb_components
	components._setup(self)
		
	self.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	
	dependency_components()
	dependency_setup()
func _enter_tree() -> void: add_to_group("actors")
func _exit_tree() -> void:  remove_from_group("actors")
	
# - freeze and freeze.
func _freeze() -> void: 
	self.velocity = Vector2.ZERO
	components.set_bypass(true)
func _unfreeze() -> void: 
	self.velocity = Vector2.ZERO
	components.set_bypass(false)
	
# - enter and exit.
func _exit() -> void: _freeze()
func _enter() -> void: _unfreeze()
	
func dependency_components() -> void: pass 	
func dependency_setup() -> void: pass 

# ---- base processes ----
func _physics_update(_delta: float) -> void:
	(self as Actor2D).move_and_slide()
	components._physics_update(_delta)
func _update(_delta: float) -> void:
	components._update(_delta)
	handle_desired_velocity(vel_input)
func _sb_input(_event: InputEvent) -> void: pass

# - speed handling.
func handle_velocity() -> void:
	self.velocity = Vector2(desired_vel).limit_length(MAX_SPEED) 
	if (self.velocity.is_equal_approx(Vector2.ZERO)): self.position = self.position.round()
func handle_desired_velocity(_dir: Vector2) -> void:
	desired_vel 	= ((_dir.normalized() * BASE_SPEED)) * speed_multiplier
	desired_speed 	= desired_vel.length()

# - direction handling.
func handle_direction(_dir: Vector2) -> void: 
	if _dir != Vector2.ZERO:
		direction = _dir
		lerped_direction = lerped_direction.lerp(_dir, 1)
func handle_heading() -> void:
		if abs(direction.x) > .5: 
			if 		direction.y > .5: heading = compass_headings.SOUTH_HORIZ
			elif 	direction.y < -.5: heading = compass_headings.NORTH_HORIZ
			else: 	heading = compass_headings.HORIZ
		else:
			if 		direction.y > .5	: heading = compass_headings.SOUTH
			elif 	direction.y < -.5	: heading = compass_headings.NORTH

# - movement logic related.
func get_calculated_speed(_speed_mult: float) -> float:
	return (BASE_SPEED * _speed_mult)

# - misc.
func get_values() -> SBVariables: return values
func set_values(_val: SBVariables) -> void: 
	if _val == null: 
		values = SBVariables.new()
		values.resource_name = "sb_variables"
		values.resource_local_to_scene = true
		return
	
	values = _val.duplicate()
	values.resource_name = "sb_variables"
	values.resource_local_to_scene = true

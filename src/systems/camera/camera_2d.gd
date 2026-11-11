@tool

class_name CCamera2D
extends Node2D

static var instance: CCamera2D

var sm: SM
var cam_root_state: State
var curr_strat: STRAT_FOLLOW = STRAT_FOLLOW.new()

# ---- components
@onready var cam: Camera2D = $camera
@onready var components: ComponentReceiver = $components_receiver

var shake_comp: CamShake

# ---- cam properties
@export_group("Camera Properties")
@export var follow_speed: float = 2.35
@export var offset: Vector2 = Vector2(0, 0): set = set_offset
@export_range(0.8, 2) var zoom: float = 1: set = set_zoom

var offset_tween: Tween
var zoom_tween: Tween

# ---- target
@export_group("Target Properties")
@export var initial_target: CanvasItem
var curr_target: CanvasItem

static func get_instance() -> CCamera2D: return instance

func _ready() -> void:
	if Engine.is_editor_hint(): 
		if initial_target != null:
			global_position = initial_target.global_position
	
	else:
		cam_root_state = CamStateRoot.new(null, null, self)
		sm = SM.build(cam_root_state)
		
		instance = self
		self.top_level = true
		self.process_mode = Node.PROCESS_MODE_PAUSABLE
		
		sm.start()
		set_target(initial_target)
		
		cam.editor_draw_screen = true
		cam.editor_draw_limits = true
	
func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	sm.update(_delta)

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	sm.phys_update(_delta)
	
# ---- cam control ----
func set_zoom(_zoom: float) -> void:
	zoom = _zoom
	cam.zoom = Vector2(_zoom, _zoom)
func set_cam_limit(_up: int, _down: int, _right: int, _left: int) -> void: 
	cam.limit_top = _up
	cam.limit_bottom = _down
	cam.limit_right = _right
	cam.limit_left = _left

func set_offset(_offset: Vector2) -> void: 
	cam.offset = _offset
	
func set_target(_target: CanvasItem) -> void:
	curr_target = _target
		
func set_override_flag(_override: bool) -> void:
	cam.top_level = _override
		
# ---- cam control (lerped, redundant) ----
func lerp_offset(_offset: Vector2, _ease: Tween.EaseType, _trans: Tween.TransitionType,  _dur: int) -> void:
	if offset_tween: offset_tween.kill()
	
	offset_tween.set_ease(_ease)
	offset_tween.set_trans(_trans)
	
	offset_tween.tween_method(set_offset, offset, _offset, _dur)
	await offset_tween.finished
func lerp_zoom(_zoom: float, _ease: Tween.EaseType, _trans: Tween.TransitionType,  _dur: int) -> void:
	if zoom_tween: zoom_tween.kill()
	
	zoom_tween.set_ease(_ease)
	zoom_tween.set_trans(_trans)
	
	zoom_tween.tween_method(set_zoom, zoom, _zoom, _dur)
	await zoom_tween.finished

# ---- shake ----
func shake(_magnitude: float, _speed: float, _dur: float) -> void: 
		if (shake_comp == null): return
	
		shake_comp.magnitude = _magnitude
		shake_comp.speed = _speed
		shake_comp.duration = _dur
		
		shake_comp.request()
		shake_comp.ignore_rotation = false

class CamShake:
	extends RefCounted
	var time_elapsed: float

	var origin_rot: float
	var got_origin_rot: bool = false

	var shake_rot_strength: float = 1
	var shake_rot_speed: float = 1

	var got_origin_pos: bool = false
	var initial_x: float
	var initial_y: float

	var magnitude: float = 1
	var speed: float = 1
	var duration: float = 1
	var decay: float = 1

	var is_decay: bool = true
	var is_shaking: bool = false
	var ignore_rotation: bool = true

	var cam: Camera2D

	func _init(
			_cam: Camera2D,
			_magnitude: float = 1, 
			_speed: float = 1, 
			_dur: float = 1) -> void:
		cam = _cam		
		magnitude = _magnitude
		speed = _speed
		duration = _dur
		
	func get_origin_pos() -> void:
		initial_x = cam.offset.x
		initial_y = cam.offset.y
		got_origin_pos = true
	func get_origin_rot() -> void:
		origin_rot = cam.rotation
		got_origin_rot = true

	func _handle(_delta: float) -> void:
		if is_shaking:	
			time_elapsed += _delta
			decay = time_elapsed * int(is_decay)
			
			var eqn_x = 0.12 * magnitude * pow(20.11, -(decay - duration)) * sin(speed * 50 * time_elapsed) + initial_x
			var eqn_y = 0.12 * magnitude * pow(20.11, -(decay - duration)) * cos((speed * 50 / .987) * (time_elapsed)) + initial_y

			cam.offset.x = eqn_x
			cam.offset.y = eqn_y
			cam.rotation_degrees = 0.05 * pow(20.87, -(decay - duration)) * sin(speed * 60 * time_elapsed)
						
			if duration - (decay) <= 0: 
				cam.offset = Vector2()
				cam.rotation_degrees = 0
				is_shaking = false
	func request() -> void: 
		time_elapsed = 0
		is_shaking = true

# -- strats
class STRAT_FOLLOW:
	extends Strategy

	var final: Vector2

	func _setup(_cam: CCamera2D) -> void: pass
	func _follow(_cam: CCamera2D, _point: Vector2) -> void: 
		_cam.global_position = _point

	func _changed() -> void: pass

class STRAT_FOLLOW_DEFAULT:
	extends STRAT_FOLLOW
	func _follow(_cam: CCamera2D, _point: Vector2) -> void:
		final = _cam.global_position.lerp(_point, Global.get_delta() * _cam.follow_speed)
		_cam.global_position = final
class STRAT_FOLLOW_SENTIENT:
	extends STRAT_FOLLOW
	
	var player: Player2D
	var calculated: Vector2

	var look_ahead_distance: float = 10
	var look_ahead: Vector2
	var MAX_LOOK_AHEAD_PIXELS := Vector2(10, 10)

	func _setup(_cam: CCamera2D) -> void:
		player = PlayerInstance.instance
		
	func _follow(_cam: CCamera2D, point: Vector2) -> void:
		if player == null:  return
		look_ahead = look_ahead.lerp(
			(player.velocity * look_ahead_distance).clamp(-MAX_LOOK_AHEAD_PIXELS, MAX_LOOK_AHEAD_PIXELS), 
			Global.get_delta() * _cam.follow_speed)
		final = point + look_ahead

		_cam.global_position = final
	func _changed() -> void: look_ahead = Vector2.ZERO

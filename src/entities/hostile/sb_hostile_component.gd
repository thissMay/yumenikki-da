class_name SBAggression
extends SBComponent

signal suspicion_changed(_suspicion: float)

var indicator_tween: Tween
var suspicion: float:
	set(_sus): 
		suspicion = clampf(_sus, 0, 100)
		suspicion_changed.emit(_sus)
var suspicion_over_zero: bool = false

@export_group("Components")
@export var behaviour_fsm: LegacyFSM
@export var suspicion_region: AreaRegion
@export var suspicion_indicator: Node2D
@export var suspicion_indicator_status: SpriteSheetFormatter

var indicator_observe_colour: Color = Color("ebaf00")
var indicator_chase_colour: Color = Color("d80c4e")

@export var target: Actor2D
@export var target_states: Array[LegacyState]

var radius: float = 0
var displacement: Vector2

@export_group("Suspicion Properties")
@export var suspicion_increase_multiplier: float = 1
@export var suspicion_decay_multiplier: float = 1


@export var suspicion_distance_threshold: float = 100
@export var min_observe_threshold: float = 40
@export var min_chase_threshold: float = 80
@export var taunt_chance: float = 0.6

@export_group("Chase Flags")
@export var emits_chase_sequence: bool = false
var in_range: bool


func _update(_delta: float) -> void: 
	if !(suspicion_region != null and suspicion_region.shape is CircleShape2D): return
	
	radius = suspicion_region.shape.radius 
	displacement = (dist_from_to(Vector2(
		Vector2(radius * cos(atan2(target.position.y - actor.position.y, target.position.x  - actor.position.x)), radius * sin(atan2(target.position.y  - actor.position.y, target.position.x  - actor.position.x)))),
		target.position - actor.position))
	in_range = displacement.length() < suspicion_distance_threshold
	
	if in_range: suspicion += suspicion_increase_multiplier * (1 / displacement.length())
	else: suspicion -= suspicion_decay_multiplier * (displacement.length() / 1000) 
	
	if suspicion >= min_observe_threshold and behaviour_fsm.get_curr_state_name() == "wander":
		behaviour_fsm.change_to_state("observe")
	
	actor.queue_redraw()
		
func _physics_update(delta: float) -> void: pass

func _setup(_sentient: Actor2D = null) -> void: 
	super(_sentient)
	_sentient.draw.connect(_draw)
	for i in target_states:
		if i != null: i.target = target
		
	suspicion_changed.connect(func(_suspicion: float): 
		if _suspicion > 1 and !suspicion_over_zero: 
			if indicator_tween != null: indicator_tween.kill()
			indicator_tween = suspicion_indicator.create_tween()
			indicator_tween.set_parallel()
			indicator_tween.tween_property(suspicion_indicator, "modulate:a", 1, 1)
			suspicion_over_zero = true
		elif _suspicion <= 1 and suspicion_over_zero:
			if indicator_tween != null: indicator_tween.kill() 
			indicator_tween = suspicion_indicator.create_tween()
			indicator_tween.set_parallel()
			indicator_tween.tween_property(suspicion_indicator, "modulate:a", 0, 1)
			suspicion_over_zero = false)

func _draw() -> void:
	if Engine.is_editor_hint():
		actor.draw_circle(Vector2.ZERO, radius, Color.YELLOW, false, 3)
		
		actor.draw_line(
			Vector2(radius * cos(atan2(target.position.y - actor.position.y, target.position.x  - actor.position.x)), radius * sin(atan2(target.position.y  - actor.position.y, target.position.x  - actor.position.x))),
			target.position - actor.position,
			Color.GREEN if displacement.length() > suspicion_distance_threshold else Color.RED,
			2)

func dist_from_to(_from: Vector2, _to: Vector2) -> Vector2:
	return _to - _from

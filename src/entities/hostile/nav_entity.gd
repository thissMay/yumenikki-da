@tool

class_name NavSentient
extends Actor2D

@export var nav_agent: NavigationAgent2D
@export var stance_fsm: SentientFSM
@export var behaviour_fsm: SentientFSM

@export_group("Navigation Properties")
@export var min_wait_time: float = 1
@export var max_wait_time: float = 3
@export var wander_radius: float = 25

var sound_player: SoundPlayer

func _ready() -> void:
	super()
	if Engine.is_editor_hint(): Utils.connect_to_signal		(draw_wander_radius, (self).draw)
	else:						Utils.disconnect_from_signal(draw_wander_radius, (self).draw)

func dependency_setup() -> void: 
	stance_fsm._setup(self)
	behaviour_fsm._setup(self)
	sound_player = get_node("sound_player")
	
func _update(_delta: float) -> void:
	super(_delta)
	stance_fsm._update(_delta)
	behaviour_fsm._update(_delta)

func _physics_update(_delta: float) -> void:
	super(_delta)
	stance_fsm._physics_update(_delta)
	behaviour_fsm._physics_update(_delta)

func draw_wander_radius() -> void: 
	(self as Node).draw_circle(
		Vector2.ZERO, 
		nav_agent.target_desired_distance * 1.1 + wander_radius, 
		Color(0.487, 0.32, 0.792, 0.208))

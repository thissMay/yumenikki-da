class_name PlayerStateMoving
extends Actor2DState

var walk: PlayerStateMoveWalk
var run: PlayerStateMoveRun

func _init(sm: SM, parent: State, actor: Actor2D):
	super(sm, parent, actor)
	walk = PlayerStateMoveWalk.new(sm, self, actor)
	run = PlayerStateMoveRun.new(sm, self, actor)

func on_phys_update(_delta: float) -> void:
	actor.handle_heading()
	actor.handle_velocity()

func get_initial() -> State:
	return walk

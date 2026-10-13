class_name PlayerStateRoot
extends Actor2DState

var idle: PlayerStateIdle
var move: PlayerStateMoving

func _init(sm: SM, parent: State, actor: Actor2D):
	super(sm, parent, actor)
	idle = PlayerStateIdle.new(sm, self, actor)
	move = PlayerStateMoving.new(sm, self, actor)
	
#func on_enter() -> void:
	
	
func get_initial() -> State:
	return idle
	

class_name CamStateRoot
extends CamState 

var state_follow: State
var state_static: State

func _init(sm: SM, parent: State, cam: CCamera2D):
	super(sm, parent, cam)
	state_static = CamStateStatic.new(sm, self, cam)
	state_follow = CamStateFollow.new(sm, self, cam)
	
func get_initial() -> State:
	return state_follow

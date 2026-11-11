class_name CamState
extends State

var cam: CCamera2D 

func _init(sm: SM, parent: State, cam: CCamera2D):
	super(sm, parent)
	self.cam = cam

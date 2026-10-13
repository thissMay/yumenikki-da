class_name Actor2DState
extends State

var actor: Actor2D

func _init(sm: SM, parent: State, actor: Actor2D):
	super(sm, parent)
	self.actor = actor
	
	
	

class_name TransitionSequencer
extends RefCounted

var sm: SM
var transition: Transition


func _init(sm: SM):
	self.sm = sm
	
func request_transition(from: State, to: State): pass
func start_transition(): pass
func end_transition(): pass

class_name GameStateRoot
extends State

var state_pregame: State
var state_menu: State
var state_active: State
var state_pause: State


func _init(sm: SM, parent: State):
	state_pregame 	= GameStatePregame.new(sm, self)
	state_active 	= GameStateActive.new(sm, self)
	state_menu 		= GameStateMenu.new(sm, self)
	state_pause 	= GameStatePause.new(sm, self)

func get_initial() -> State:
	return state_pregame

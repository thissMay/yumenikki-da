class_name GameStateActive
extends State

enum SUB_STATES {NONE, INVENTORY, CUTSCENE}
var curr_substate: SUB_STATES = SUB_STATES.NONE

func _init(sm: SM, parent: State):
	super(sm, parent)

func on_enter() -> void:
	Game.player_hud.visible 				= true
	Game.options_menu.visible 				= false
	Game.instance.inventory_menu.visible 	= false

func on_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_esc_menu"): 
		sm.change_state(self, (parent as GameStateRoot).state_pause)

func on_update(_delta: float) -> void:
	for s in Utils.get_group_arr("actors"):
		if s != null:
			if s.can_process(): s._update(_delta)
			
func on_phys_update(_delta: float) -> void:
	for s in Utils.get_group_arr("actors"):
		if s != null:
			if s.can_process(): s._physics_update(_delta)

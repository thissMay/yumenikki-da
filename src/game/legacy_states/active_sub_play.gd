extends LegacyState

@export var dream_component: Component

var sentients_updated: bool = false
var sentients: Array
var player: Player

@onready var player_updated := EventListener.new(self, "PLAYER_UPDATED")

func _ready() -> void:
	dream_component._setup()
	player = Player.Instance.get_pl()
	player_updated.do_on_notify(func(): player = EventManager.get_event_param("PLAYER_UPDATED")[0], "PLAYER_UPDATED")
		
func _state_enter() -> void:

	await Game.main_tree.process_frame
	PhysicsServer2D.set_active(true)
	InputManager.request_curr_controller_change(InputManager.sb_input_controller)
	
	for s in Utils.get_group_arr("actors"): 
		if s != null: s._unfreeze()

	dream_component._enter()
func _state_exit() -> void:
	await Game.main_tree.process_frame
	PhysicsServer2D.set_active(false)
	
	for s in Utils.get_group_arr("actors"): 
		if s != null: s._freeze()
	
	dream_component._exit()
	
func _state_input(event: InputEvent) -> void:
	dream_component._input_pass(event)
	if Input.is_action_just_pressed("ui_esc_menu"):
		Game.pause_options(true)
		
	if player != null: (player as Player_YN)._sb_input(event)

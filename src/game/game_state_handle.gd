extends Component

@export var game_state_fsm: LegacyFSM

var state_requests_listener: EventListener

func _setup() -> void:
	game_state_fsm._setup(Game.instance)
	state_requests_listener = EventListener.new(self, "SCENE_PUSHED", "SCENE_POPPED")
	state_requests_listener.do_on_notify(update_game_state, "SCENE_PUSHED", "SCENE_POPPED")
	
func update_game_state() -> void: 
	var curr_res_scene = SceneManager.curr_scene_resource
	var state_id: String = ""
	
	# temp.
	if curr_res_scene == null: return
	
	if game_state_fsm.get_curr_state_name() == Game.STATE_PRELOAD_CONTENT: 
		return
	
	if 	curr_res_scene == null or \
		curr_res_scene.resource_path in GameBootstrapper.PREGAME_SCENES: 
		state_id = Game.STATE_PREGAME
	
	else: 													
		state_id = Game.STATE_ACTIVE
	
	game_state_fsm.change_to_state(state_id)

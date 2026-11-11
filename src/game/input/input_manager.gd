class_name InputManager
extends GameDependency

# - WASD and Arrow Keys are going to be represented ina VECTOR 4.
# Vector4(S | DOWN_ARROW, D | RIGHT_ARROW, W | UP_ARROW, A | LEFT_ARROW )
static var sb_input_controller	: SBInputController
static var def_input_controller	: UIInputController
static var curr_controller		: InputController

static var dir_input				: Vector2i
static var direction_vector_4		: Vector4i

static func _setup() -> void:
	sb_input_controller 	= SBInputController.new()
	def_input_controller 	= UIInputController.new()
	
static func request_curr_controller_change(_controller: InputController) -> void: 
	curr_controller = _controller
	
static func _update(_delta: float) -> void:
	
	direction_vector_4 = Vector4i(
		int(Input.is_action_pressed("usr_right")), # pos x.
		int(Input.is_action_pressed("usr_down")), # pos y.
		int(Input.is_action_pressed("usr_left")), # neg x
		int(Input.is_action_pressed("usr_up"))      # neg y
		)
	
	dir_input = Vector2i(
		direction_vector_4.x - direction_vector_4.z,
		direction_vector_4.y - direction_vector_4.w)

	if curr_controller != null: 
		curr_controller.dir_input = dir_input
		curr_controller._update(_delta)
		
static func _input_pass(_event: InputEvent) -> void: 
	if curr_controller != null: 
		curr_controller._handled_input(_event)
static func _unhandled_input_pass(_event: InputEvent) -> void:
	if curr_controller != null: 
		curr_controller._unhandled_input(_event)
	

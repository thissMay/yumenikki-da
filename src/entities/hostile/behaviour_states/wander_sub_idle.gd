extends SBState

@export var idle_timer: Timer
@export var repath_timer: Timer
var wander_radius: float
var wander_vector: Vector2
var direction: Vector2i = Vector2i(1, 1)

func _setup() -> void:
	wander_radius = sentient.wander_radius
	
	if idle_timer == null or repath_timer == null:
		assert(idle_timer == null or repath_timer == null, "NavSentient, Wander LegacyState :: Idle Timer not found...")
		return
	idle_timer.autostart = false
	idle_timer.one_shot = true
	idle_timer.timeout.connect(func():
		request_transition_to("wander_move"))
	
	repath_timer.autostart = false
	repath_timer.one_shot = false
	repath_timer.timeout.connect(func(): update_random_wander_point())
	repath_timer.wait_time = 2
	
func _state_enter() -> void:
	update_random_wander_point()
	sentient.velocity = Vector2.ZERO
	idle_timer.wait_time = randf_range(sentient.min_wait_time, sentient.max_wait_time)
	
	idle_timer.start()
	repath_timer.start()

func _state_exit() -> void:
	idle_timer.stop()
	repath_timer.stop()
	
func update_random_wander_point() -> void: 
	var direction_arr = [-1, 0, 1]
	direction = Vector2i(direction_arr.pick_random(), direction_arr.pick_random())
	if direction == Vector2i.ZERO: update_random_wander_point()
	
	sentient.nav_agent.target_position = sentient.position + Vector2(
		sign(direction.x) * ((sentient.nav_agent.target_desired_distance * 1.1) + wander_radius), 
		sign(direction.y) * ((sentient.nav_agent.target_desired_distance * 1.1) + wander_radius))

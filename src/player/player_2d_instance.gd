class_name PlayerInstance
extends GameDependency

const PLAYER_2D_PATH: String = "res://src/player/2D/madotsuki.tscn"

static var instance: Player2D
static var is_running: bool = false

static var door_went_flag: bool = false
static var door_listener: EventListener

const ERR_SOUNDS := [
	preload("res://src/audio/se/voice_mado_no-1.WAV"), 
	preload("res://src/audio/se/voice_mado_no-2.WAV")]
	
static var equipment_pending	: PLEffect = null
static var equipment_favourite	: PLEffect = null
static var effects_inventory: Array

static func _setup() -> void: 
	instance = preload(PLAYER_2D_PATH).instantiate()
	Game.instance.add_child(instance)
	print(instance.is_node_ready())
	
	door_listener = EventListener.new(null, "PLAYER_DOOR_USED", "SCENE_CHANGE_SUCCESS")
	door_listener.do_on_notify(func(): door_went_flag = true, "PLAYER_DOOR_USED")
	door_listener.do_on_notify(func(): 
		
		for points: SpawnPoint in Utils.get_group_array("spawn_points"):
			if points == null or points.scene_path.is_empty(): continue

			# if we found a spawn point 
			if  load(points.scene_path) == SceneManager.prev_scene_resource and \
				door_went_flag and \
				EventManager.get_event_param("PLAYER_DOOR_USED")[0] == points.connection_id:
					
					teleport_player(points.global_position, true)
				
					if points.as_sibling: instance.reparent(points.parent_instead_of_self.get_parent())
					else: instance.reparent(points.parent_instead_of_self)
					
					door_went_flag = false
					break,
		"SCENE_CHANGE_SUCCESS")

static func _update(_delta: float) -> void: 
	is_running = Input.is_action_pressed(InputConstants.USR_PL_RUN) 
	if exists(): instance._update(_delta)
static func _physics_update(_delta: float) -> void: 
	if exists(): instance._physics_update(_delta)


static func teleport_player(_pos: Vector2, w_camera: bool = false) -> void:
	if instance:
		instance.global_position = _pos
		if w_camera and CCamera2D.instance.initial_target == instance: 
			CCamera2D.instance.global_position = instance.global_position


static func exists() -> bool: return (instance != null)

static func get_pos(_global: bool = true) -> Vector2:
	if exists(): 
		if _global	: return instance.global_position
		else		: return instance.position
	return Vector2.ZERO
static func is_moving() -> bool:
	if exists(): return instance.is_moving
	return exists()
# --- 

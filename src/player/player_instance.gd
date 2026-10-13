class_name PlayerInstance
extends RefCounted

static var instance: Player 
static var is_setup: bool = false

static var door_went_flag: bool = false
static var door_listener: EventListener

const DEFAULT_EQUIPMENT: PLEffect = preload("res://src/player/2D/madotsuki/effects/_none/_no_effect.tres")

static var equipment_pending	: PLEffect = null
static var equipment_favourite	: PLEffect = null
static var effects_inventory: Array

static func setup() -> void: 
	if is_setup: return
	is_setup = true
	
	door_listener = EventListener.new(null, "PLAYER_DOOR_USED", "SCENE_CHANGE_SUCCESS")
	door_listener.do_on_notify(func(): door_went_flag = true, "PLAYER_DOOR_USED")
	door_listener.do_on_notify(func(): 
		
		for points: SpawnPoint in Utils.get_group_arr("spawn_points"):
			if points == null or points.scene_path.is_empty(): continue

			# if we found a spawn point 
			if  load(points.scene_path) == SceneManager.prev_scene_resource and \
				door_went_flag and \
				EventManager.get_event_param("PLAYER_DOOR_USED")[0] == points.connection_id:
					
					teleport_player(points.global_position, points.heading, true)
				
					if points.as_sibling: instance.reparent(points.parent_instead_of_self.get_parent())
					else: instance.reparent(points.parent_instead_of_self)
					
					door_went_flag = false
					break,
		"SCENE_CHANGE_SUCCESS")

	
static func teleport_player(_pos: Vector2, _heading: Actor2D.compass_headings, w_camera: bool = false) -> void:
	if instance:
		instance.global_position = _pos
		instance.heading = _heading
		if w_camera and CameraHolder.instance.initial_target == instance: 
			CameraHolder.instance.global_position = instance.global_position


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

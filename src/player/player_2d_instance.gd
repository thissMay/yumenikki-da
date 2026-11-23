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

static func _setup() -> void: 
	instance = preload(PLAYER_2D_PATH).instantiate()
	Game.instance.add_child(instance)
	
	#door_listener = EventListener.new(null, "PLAYER_DOOR_USED", "SCENE_CHANGE_SUCCESS")
	#door_listener.do_on_notify(func(): door_went_flag = true, "PLAYER_DOOR_USED")
	#door_listener.do_on_notify(func(): 
		#
		#for points: SpawnPoint in Utils.get_group_array("spawn_points"):
			#if points == null or points.scene_path.is_empty(): continue
#
			## if we found a spawn point 
			#if  load(points.scene_path) == SceneLoader.prev_scene_resource and \
				#door_went_flag and \
				#EventManager.get_event_param("PLAYER_DOOR_USED")[0] == points.connection_id:
					#
					#teleport_player(points.global_position, true)
				#
					#if points.as_sibling: instance.reparent(points.parent_instead_of_self.get_parent())
					#else: instance.reparent(points.parent_instead_of_self)
					#
					#door_went_flag = false
					#break,
		#"SCENE_CHANGE_SUCCESS")


static func _update(_delta: float) -> void: 
	is_running = Input.is_action_pressed(InputConstants.USR_PL_RUN) 
	if instance != null: instance._update(_delta)
static func _physics_update(_delta: float) -> void: 
	if instance != null: instance._physics_update(_delta)

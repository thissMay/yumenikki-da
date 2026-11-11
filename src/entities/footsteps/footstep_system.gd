class_name FootstepComponent
extends Node2D

@export var shadow_renderer: Sprite2D

const DEFAULT_FOOTSTEPS: Array[AudioStream] = [
	preload("res://src/audio/se/footstep_null-1.wav"),
	preload("res://src/audio/se/footstep_null-2.wav"),
	preload("res://src/audio/se/footstep_null-3.wav")
	]
	
static var global_footstep: Array[AudioStream] = DEFAULT_FOOTSTEPS
	
var curr_anim: CompressedTexture2D 		= preload("res://src/entities/footsteps/default.png")

var sound_player: SoundPlayer2D
var area: Area2D

var floor_priority: TileMapLayer
var greatest_index: int = -50
var material_id: int = 0

func _on_bypass_enabled() -> void:
	floor_priority = null

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_POSTINITIALIZE:
			sound_player 		= $sound_player
			area 				= $terrain_detector
			
			area.monitorable	= true
			area.monitoring 	= true
			area.input_pickable = false
			
			area.body_shape_exited.connect(_on_body_shape_exited)
			area.body_shape_entered.connect(_on_body_shape_entered)
			
			sound_player.max_distance = 250

func create_footstep(info: FootstepInfo) -> void:  
	#curr_anim = curr_set.footstep_anim
	spawn(info.position)
	sound_player.play_random_sound(
		global_footstep, 
		clampf(2.1 *(log(info.power + 1)), 0.5, 1.75), 
		clampf(randf_range(0.75, info.power), 0.75, 1.2))
		
func spawn(position: Vector2) -> void: 
	if Optimization.footstep_instances < Optimization.FOOTSTEP_MAX_INSTANCES:
		var footstep_fx := FootstepDust.new(curr_anim)
		self.add_child(footstep_fx)
		footstep_fx.global_position = position

func _on_body_shape_entered(
	_body_rid: RID, 
	_body: Node2D, 
	_body_shape_index: int, 
	_local_shape_index: int) -> void: pass
								
				
func _on_body_shape_exited(
	_body_rid: RID, 
	_body: Node2D, 
	_body_shape_index: int, 
	_local_shape_index: int) -> void:
		if _body is FootstepTileMap: pass
					
func scan_ground_material() -> void: pass
		
class FootstepInfo:
	extends RefCounted
	var power: float
	var position: Vector2
	
	func _init(power: float, position: Vector2) -> void: 
		self.power = power
		self.position = position
	
class FootstepDust:
	extends SpriteSheetFormatterAnimated

	func _init(_anim: CompressedTexture2D, ) -> void:
		Optimization.footstep_instances += 1
		
		self.frame_dimensions = Vector2i(48, 48)
		self.fps = 20
		self.loop = false
		
		self.z_index = -1
		self.top_level = true
		
		set_sprite(_anim)	
		
	func _exit_tree() -> void:
		Optimization.footstep_instances -= 1
		
	func _ready() -> void:
		self.play(texture)
		await self.animation_finished
		self.queue_free()

class_name Footstep
extends SBComponent

# update the sounds later.
# one more thing: make a ground_material resource that holds a list
# of all random sound effects for the ground.

@export var shadow_renderer: Sprite2D

const DEFAULT_FOOTSTEP: AudioStream 	= preload("res://src/audio/se/footstep_null-1.wav")


var curr_anim: CompressedTexture2D = preload("res://src/entities/footsteps/default.png")

var footstep_se_player: SoundPlayer2D
var area: Area2D

var floor_priority: TileMapLayer
var greatest_index: int = -50
var material_id: int = 0


func _on_bypass_enabled() -> void:
	floor_priority = null

func _setup(_sentient: Actor2D = null) -> void:
	super(_sentient)
	
	footstep_se_player 	= $sound_player
	area 				= $terrain_detector
	
	area.monitorable	= true
	area.monitoring 	= true
	area.input_pickable = false
	
	area.body_shape_exited.connect(_on_body_shape_exited)
	area.body_shape_entered.connect(_on_body_shape_entered)
	
	#curr_set = default_footstep_mat
	#shadow_renderer.visible = !curr_set.transparent_tile
	footstep_se_player.max_distance = 250

func initate_footstep() -> void:  
	#curr_anim = curr_set.footstep_anim
	spawn_footstep_fx()
	#play_footstep_sound(curr_set.pick_random() if curr_set.size() > 0 else DEFAULT_FOOTSTEP)
func spawn_footstep_fx() -> void: 
	if Optimization.footstep_instances < Optimization.FOOTSTEP_MAX_INSTANCES:
		var footstep_fx := FootstepDust.new(curr_anim)
		self.add_child(footstep_fx)
		footstep_fx.global_position = actor.global_position

func play_footstep_sound(_footstep_se: AudioStream) -> void: 
	footstep_se_player.play_sound(
		_footstep_se, 
		clampf(2.1 *(log(actor.noise + 1)), 0.5, 1.75), 
		clampf(randf_range(0.75, actor.noise), 0.75, 1.2))	

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
		
class FootstepDust:
	extends SpriteSheetFormatterAnimated

	func _init(_anim: CompressedTexture2D, ) -> void:
		Optimization.footstep_instances += 1
		
		self.frame_dimensions = Vector2i(48, 48)
		self.fps = 22
		self.loop = false
		
		self.z_index = -1
		self.offset.y = -10
		self.top_level = true
		
		set_sprite(_anim)	
		
	func _exit_tree() -> void:
		Optimization.footstep_instances -= 1
		
	func _ready() -> void:
		self.play(texture)
		await self.animation_finished
		self.queue_free()

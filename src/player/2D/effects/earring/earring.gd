extends SBComponent

@export var sound_player: SoundPlayer
@export var field: Area2D
@export var glow: Sprite2D
@export var arrow: Sprite2D

var closest: Interactable
var within_prox: Array[Area2D]
var distances: Array[float]

var shortest_dist: float = 200

var field_radius: float

func _setup(_sb: Actor2D = null) -> void:
	super(_sb)
	
	assert(sound_player != null, "MEMORIAM Error: Lin Pendant SoundPlayer does not exist!")
	assert(field != null, "MEMORIAM Error: Lin Pendant Field does not exist!")
	assert(glow != null, "MEMORIAM Error: Lin Pendant Glow does not exist!")
	
	within_prox.resize(5)
	distances.resize(5)
	field_radius = ((field.get_node("circle") as CollisionShape2D).shape as CircleShape2D).radius
	
	sound_player.stream = preload("res://src/audio/amb/amb_lin_pendant.ogg")
	sound_player.autoplay = false
	sound_player.play()
	
	sound_player.volume_db =  	clampf(37.45 * ((field_radius - shortest_dist) / field_radius * 2) - 35, -50, -8)
	glow.modulate.a = clampf(((field_radius - shortest_dist) / field_radius * 2), 0, 1)
	
	field.area_entered.connect(func(interactable: Area2D): 
		if interactable is Interactable: 
			for empty in range(within_prox.size()): 
				if within_prox[empty] == null: 
					within_prox[empty] = interactable
					break)
	field.area_exited.connect(func(interactable: Area2D): 
		if interactable is Interactable: 
			within_prox[within_prox.find(interactable)] = null)
	
# TODO:
# fix the closest distance calculation.

func _update(_delta: float) -> void:
	for i in range(within_prox.size()):
		if within_prox[i] != null: 
			distances[i] = (self.global_position.distance_to(within_prox[i].global_position))
	
	for i in range(distances.size()):
		if within_prox[i] != null: 
			shortest_dist = distances[i]
			closest = within_prox[i]
			break
		
	sound_player.volume_db =  	clampf(37.45 * ((field_radius - shortest_dist) / field_radius * 2) - 35, -50, -8)
	glow.modulate.a = 			clampf(((field_radius - shortest_dist) / field_radius * 2), 0, 1)
	glow.rotation_degrees += .235
	
	if closest != null:
		arrow.global_rotation = atan2(distance_to(closest).x, -distance_to(closest).y)
	
func distance_to(_target: Node2D) -> Vector2:
	return _target.global_position - arrow.global_position

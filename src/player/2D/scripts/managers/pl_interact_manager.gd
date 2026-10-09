class_name PLInteractionManager
extends SBComponent

@export var field: Area2D
@export var ray_direction: Vector2
@export var ray_distance: float = 35

signal interactable_found(interactable)
signal interactable_lost()
var found: bool = false

const COOL_DOWN = 1.5
var interaction_cooldown: float = COOL_DOWN
var cooldown: bool = false
var curr_interactable: Node

var prompt_icon: Sprite2D
var prompt_tween: Tween

var closest_interactable_threshold: float = 100
var interactables: Array[Interactable] 

func _ready() -> void:
	prompt_icon = $prompt
	field = $field
	
	field.collision_layer = 2
	field.collision_mask = 2

	interactables.resize(5)
	field.area_entered.connect(interactable_entered)
	field.area_exited.connect(interactable_exited)
	
	interactable_found.connect(func(interactable):
		AudioService.play_sound(load("res://src/audio/se/se_interaction_prompt.wav"), 0.1, 0.8)
		prompt_icon.global_position = actor.global_position - Vector2(0, 24)
		show_prompt(true))
	interactable_lost.connect(func():
		show_prompt(false))
	
	
func _update(delta: float) -> void:
	handle_field()
	field.rotation = actor.direction.angle()
	
	if cooldown: 
		interaction_cooldown -= delta
		if interaction_cooldown <= 0: 
			cooldown = false 
			interaction_cooldown = COOL_DOWN
			
	if (curr_interactable != null and 
		!found and !curr_interactable.secret)	: 
			interactable_found.emit(curr_interactable)
			found = true
	elif found and curr_interactable == null: 
		interactable_lost.emit()
		found = false
	
func handle_field() -> void: 
	for i in range(interactables.size()):
		if interactables[i] != null:
			if interactables[i].global_position.distance_to(self.global_position) < closest_interactable_threshold: 
				closest_interactable_threshold = interactables[i].global_position.distance_to(self.global_position)
				curr_interactable = interactables[i] 
			else:
				closest_interactable_threshold = 100
				break
		else: 
			if interactables[i - 1]: curr_interactable = interactables[i - 1]
			else: curr_interactable = null
			break
func handle_interaction(_choice: int = 0) -> void: 
	if !cooldown and curr_interactable != null:
	
		if 	curr_interactable is Interactable and curr_interactable.can_interact : 
			Utils.connect_to_signal(
				AudioService.play_sound.bind(Player.ERR_SOUNDS.pick_random()), 
				curr_interactable.fail, 
				CONNECT_ONE_SHOT)
					
			curr_interactable.interact()
			cooldown = true	
# ---- signals -----
func interactable_entered(_inact: Area2D) -> void: 
	if _inact is Interactable:
		for i in range(interactables.size()):
			if interactables[i] == null: interactables[i] = _inact
			break
func interactable_exited(_inact: Area2D) -> void: 
	if _inact is Interactable:
		interactables[interactables.find(_inact)] = null

# ----

func show_prompt(_show: bool) -> void: 
	match _show:
		true: prompt_show_animation()
		false: prompt_hide_animation()

func prompt_show_animation() -> void: 
	prompt_icon.visible = true
	
	if prompt_tween != null: prompt_tween.kill()
	prompt_tween = prompt_icon.create_tween()
	
	prompt_icon.scale = Vector2(.2, 2)
	prompt_icon.self_modulate.a = 0
	
	prompt_tween.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	prompt_tween.set_parallel()
	
	prompt_tween.tween_property(prompt_icon, "self_modulate:a", 1, .5)
	prompt_tween.tween_property(prompt_icon, "scale", Vector2.ONE, .5)
func prompt_hide_animation() -> void:
	if prompt_tween != null: prompt_tween.kill()
	prompt_tween = prompt_icon.create_tween()
	
	prompt_tween.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	prompt_tween.set_parallel()

	prompt_tween.tween_property(prompt_icon, "self_modulate:a", 0, .5)
	prompt_tween.tween_property(prompt_icon, "scale", Vector2(2, .2), .5)
	
	await prompt_tween.finished
	prompt_icon.visible = false

func _input_pass(_input: InputEvent) -> void: 
	if 	 Input.is_physical_key_pressed(KEY_E): actor.quered_interact.emit(actor, 0)
	elif Input.is_physical_key_pressed(KEY_R): actor.quered_interact.emit(actor, 1)

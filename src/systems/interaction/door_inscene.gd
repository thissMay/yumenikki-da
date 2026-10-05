@tool

class_name TeleportationDoor
extends Interactable

@export var spawn_point: SpawnPoint
@export var target_door: TeleportationDoor
@export var parallel: bool = false

func _setup() -> void:
	super()
	spawn_point = Utils.get_child_node_or_null(self, "spawn_point")
	if spawn_point == null:
		spawn_point = await Utils.add_child_node(self, SpawnPoint.new(), "spawn_point")
		spawn_point.parent_instead_of_self = self.get_parent()
	if Engine.is_editor_hint(): set_process(true)		

func _draw() -> void:
	if Engine.is_editor_hint():
		if target_door != null:
			draw_line(Vector2.ZERO, target_door.global_position - self.global_position, Color.RED)
			target_door.target_door = self if target_door.parallel else null
			
func _process(delta: float) -> void:
	if Engine.is_editor_hint(): 
		queue_redraw()
		if target_door == self: target_door = null

func _interact() -> void:
	if target_door != null and target_door.spawn_point:
		
		EventManager.invoke_event("PLAYER_DOOR_TELEPORTATION")
		EventManager.invoke_event("CUTSCENE_START_REQUEST")
		await Game.screen_transition.fade(ScreenTransition.DEFAULT_GRADIENT, 0, 1)
		
		Player.Instance.teleport_player(target_door.spawn_point.global_position, target_door.spawn_point.heading)
		Player.Instance.get_pl().reparent(target_door.get_parent())
		
		Game.screen_transition.fade(ScreenTransition.DEFAULT_GRADIENT, 1, 0)
		EventManager.invoke_event("CUTSCENE_END_REQUEST")
	

extends Node

var scene_entered: EventListener

var scene_stack: Stack
var scene_node: SceneNode

var is_scene_change_pending: bool = false
var is_load_finished: bool = false

var load_progress: Array[int] = [0]
var scene_load_err_check: Error
var scene_load_status: ResourceLoader.ThreadLoadStatus

func _init() -> void:
	if scene_stack == null:  	scene_stack 		= Stack.new()
	if scene_entered == null: 	scene_entered 		= EventListener.new(null, "SCENE_TREE_ENTERED")

func handle_scene_load(scene: PackedScene) -> ResourceLoader.ThreadLoadStatus:
	if 	scene == null or \
		is_load_finished or \
		!ResourceLoader.exists(scene.resource_path):
		return ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED
	
	scene_load_status = ResourceLoader.load_threaded_get_status(scene.resource_path, load_progress)
	
	if scene_load_err_check == OK:
		match scene_load_status:
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE: # - 0
				print_rich("[b]SceneLoader // Loading :: Scene (as resource) is invalid. Please check the resource's status.[/b]")
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED | ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED: # - 2 or 3
				is_load_finished = true
	
	return scene_load_status
	
func _setup() -> void: 
	scene_entered.do_on_notify(
		func(): 
			var scene = EventManager.get_event_param("SCENE_TREE_ENTERED")[0]
			handle_scene_push(EventManager.get_event_param("SCENE_TREE_ENTERED")[0]), 
			"SCENE_TREE_ENTERED"
			)
		
	handle_scene_push(get_tree().current_scene)
	
# ---------- 	SCENES LOADER / UNLOADERS 		---------- #
func load_scene(_scene: PackedScene, _push_to_stack: bool = true) -> void:
	if ResourceLoader.exists(_scene.resource_path) and _scene.can_instantiate():
		var scene_instance: SceneNode
		var result: ResourceLoader.ThreadLoadStatus= await handle_scene_load(_scene)
		
		scene_load_err_check = ResourceLoader.load_threaded_request(_scene.resource_path)
		is_load_finished 	= false
		
		if result == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			scene_instance = _scene.instantiate()
			
			if _push_to_stack: 
				handle_scene_push(scene_instance)
			
			EventManager.invoke_event("SCENE_LOADED", _scene)
					
		is_load_finished 	= true
		
		print_rich(str("[color=yellow]SceneLoader // Load Status: %s [/color]" % scene_load_status))
		print_rich("[color=yellow]SceneLoader // Loading :: Loading Scene was a success![/color]")

func handle_scene_push(_scene_node: SceneNode) -> void:
	if _scene_node == null: return
	
	if 	_scene_node.get_parent() == null: 
		Game.scene_container.add_child(_scene_node)
	else: 	
		_scene_node.reparent.call_deferred(Game.scene_container)

	EventManager.invoke_event("SCENE_PUSHED", _scene_node)
	scene_stack.push(_scene_node)
	
func handle_scene_pop() -> void:
	var scene_node: SceneNode = scene_stack.pop()
	print_rich(str("[color=yellow]SceneLoader // Scene Pop: %s [/color]" % scene_node))
	EventManager.invoke_event("SCENE_POPPED")
	
func change_scene_to(_scene: PackedScene, _fade_in: bool = true, _fade_out: bool = true) -> void:
	if _scene == null or !ResourceLoader.exists(_scene.resource_path): 
		print_rich("[color=yellow]SceneLoader // Scene Change :: Scene does not exist. [/color]")
		return
		
	if scene_node != null:
		if !is_scene_change_pending:
			is_scene_change_pending = true
			EventManager.invoke_event("SCENE_CHANGE_REQUEST")
			scene_stack.queue_pop()
			
			if _fade_in: await Game.screen_transition.fade(ScreenTransition.DEFAULT_GRADIENT, 0, 1)
			Global.scene_unloaded.emit()
			
			handle_scene_pop()
			await Game.main_tree.process_frame
			
			if _fade_out: Game.screen_transition.fade(ScreenTransition.DEFAULT_GRADIENT, 1, 0)
			await load_scene(_scene)

			print_rich("[color=green]SceneLoader // Scene Change :: Success.[/color]")
			EventManager.invoke_event("SCENE_CHANGE_SUCCESS", _scene.resource_path)
				
			is_scene_change_pending = false
			
	else: 
		EventManager.invoke_event("SCENE_CHANGE_FAIL")
		print_rich("[color=yellow]SceneLoader // Scene Change :: Scene does not exist. [/color]")


func get_scene_resource() -> Resource:
	if (scene_node != null): return load(scene_node.scene_file_path)
	return null
	
func get_scene_resource_path() -> String:
	if (scene_node != null): return get_scene_resource().resource_path
	return ""

extends Node

var scene_entered: EventListener

var scene_stack: Stack
var scene_node: SceneNode

var curr_scene_resource: PackedScene
var prev_scene_resource: PackedScene

var scene_change_pending: bool = false

# ---------- 	BACKGROUND LOADING 		---------- #
var load_requested: bool = false
var bg_load_finished: bool = false

var load_progress: Array[int] = [0]
var scene_load_err_check: Error
var scene_load_status: ResourceLoader.ThreadLoadStatus

var result: ResourceLoader.ThreadLoadStatus

func handle_scene_resource_load(scene: PackedScene) -> ResourceLoader.ThreadLoadStatus:
	if scene == null: 
		print("case one")
		return ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED
	if !load_requested or bg_load_finished: 
		print("case two")
		return ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED
	if scene == curr_scene_resource or !ResourceLoader.exists(scene.resource_path): 
		print("case tree")
		return ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED
	
	scene_load_status = ResourceLoader.load_threaded_get_status(scene.resource_path, load_progress)
	
	if scene_load_err_check == OK:
		match scene_load_status:
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE: # - 0
				print_rich("[b]SceneManager // Loading :: Scene (as resource) is invalid. Please check the resource's status.[/b]")
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED | ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED: # - 2 or 3
				bg_load_finished = true
	
	return scene_load_status
func _setup() -> void: 
	scene_stack 		= Stack.new()
	scene_entered 		= EventListener.new(null, "SCENE_TREE_ENTERED")
	
	scene_entered.do_on_notify(func(): 
		var scene = EventManager.get_event_param("SCENE_TREE_ENTERED")[0]
		if scene.manager != null: return
		handle_scene_push(EventManager.get_event_param("SCENE_TREE_ENTERED")[0]), 
		"SCENE_TREE_ENTERED")
		
# ---------- 	SCENES LOADER / UNLOADERS 		---------- #
func load_scene(_scene: PackedScene, _push_to_stack: bool = true) -> void:
	if ResourceLoader.exists(_scene.resource_path) and _scene.can_instantiate():
		var scene_instance: SceneNode
		scene_load_err_check = ResourceLoader.load_threaded_request(_scene.resource_path)
		load_requested 		= true
		bg_load_finished 	= false
		
		result = await handle_scene_resource_load(_scene)
				
		if result == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			prev_scene_resource = curr_scene_resource
			scene_instance = _scene.instantiate()
			scene_instance.manager = self
			
			if _push_to_stack: 
				handle_scene_push(scene_instance)
			
			EventManager.invoke_event("SCENE_LOADED", _scene)
					
		load_requested 		= false
		bg_load_finished 	= true
		
		print_rich(str("[color=yellow]SceneManager // Load Status: %s [/color]" % scene_load_status))
		print_rich("[color=yellow]SceneManager // Loading :: Loading Scene was a success![/color]")

	else: 
		curr_scene_resource = null

func handle_scene_push(_scene_node: SceneNode) -> void:
	# - bail out in case we were already taken care of.
	
	if _scene_node == null or _scene_node.initialized: return
	scene_node = _scene_node
	
	curr_scene_resource = load(_scene_node.scene_file_path) if !_scene_node.scene_file_path.is_empty() else null
	if 		_scene_node.get_parent() == null: 
		Game.scene_container.add_child(_scene_node)
	else: 	
		_scene_node.reparent.call_deferred(Game.scene_container)
		await Game.main_tree.process_frame

	_scene_node.initialize()
	EventManager.invoke_event("SCENE_PUSHED", _scene_node)
	
	scene_stack.push(_scene_node)
func handle_scene_pop() -> void:
	print_rich(str("[color=yellow]SceneManager // Scene Pop: %s [/color]" % scene_stack.pop()))
	EventManager.invoke_event("SCENE_POPPED")
	

func change_scene_to(_scene: PackedScene, _fade_in: bool = true, _fade_out: bool = true) -> void:
	if _scene == null or !ResourceLoader.exists(_scene.resource_path): 
		print_rich("[color=yellow]SceneManager // Scene Change :: Scene does not exist. [/color]")
		return
		
	if scene_node and _scene and _scene != curr_scene_resource:
		if !scene_change_pending:
			scene_change_pending = true
			EventManager.invoke_event("SCENE_CHANGE_REQUEST")
			Global.change_to_state("CHANGING_SCENES")
			scene_stack.queue_pop()
			
			if _fade_in: await Game.screen_transition.fade(ScreenTransition.DEFAULT_GRADIENT, 0, 1)
			Global.scene_unloaded.emit()
			
			handle_scene_pop()
			await Game.main_tree.process_frame
			Global.scene_loaded.emit()
			
			if _fade_out: Game.screen_transition.fade(ScreenTransition.DEFAULT_GRADIENT, 1, 0)
			await load_scene(_scene)

			print_rich("[color=green]SceneManager // Scene Change :: Success.[/color]")
			EventManager.invoke_event("SCENE_CHANGE_SUCCESS", _scene.resource_path)
				
			scene_change_pending = false
			
	else: 
		EventManager.invoke_event("SCENE_CHANGE_FAIL")
		print_rich("[color=yellow]SceneManager // Scene Change :: Scene does not exist. [/color]")


func _update(_delta: float) -> void: 		if scene_node: scene_node._update(_delta)
func _physics_update(_delta: float) -> void: if scene_node: scene_node._physics_update(_delta)
# ---------- 									---------- #
# ----
# here are the scene events called in order:
#	1. -> SCENE_CHANGE_REQUEST
#			-> called prior to unloading.
#	2. -> SCENE_UNLOADED
#	3. -> SCENE_LOADED
#			-> called prior to loading.
#	4. -> SCENE_CHANGE_SUCESS / SCENE_CHANGE_FAIL
#			-> called after loading.
# ----

@tool

class_name OnInteract
extends Sequence

var interactable: Node

func _ready() -> void: 
	super()
	
	interactable = get_parent()
	if interactable == null or !(interactable is Interactable): return
	
	Utils.connect_to_signal(SequencerManager.invoke.bind(self), interactable.interacted)
	Utils.connect_to_signal(interactable.success.emit, success)
	Utils.connect_to_signal(interactable.fail.emit, fail)

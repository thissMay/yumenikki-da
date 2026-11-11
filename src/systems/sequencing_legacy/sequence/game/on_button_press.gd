@tool

class_name OnButtonPress
extends Sequence

var button: Node

func _ready() -> void: 
	super()
	process_mode = Node.PROCESS_MODE_DISABLED	
	
	button = get_parent()
	if button == null or !(button is GUIPanelButton): return
	
	(button as GUIPanelButton).pressed.connect(func(): SequencerManager.invoke(self))

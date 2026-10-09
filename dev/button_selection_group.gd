class_name ButtonSelectionGroup
extends Container

@export var initial_focus: BaseButton 

func _ready() -> void:
	var buttons: Array[Button] = []
	
	for i in get_children(): 
		if i is BaseButton: buttons.append(i)
		
	if buttons.size() == 0: return
	if initial_focus == null: initial_focus = buttons[0]
	

extends SM

@export var to_save_section	: AbstractButton
@export var to_load_section	: AbstractButton

@export var prompt_window	: Control
@export var prompt_yes		: GUIPanelButton
@export var prompt_no		: GUIPanelButton

@export var slots			: Array[GUIPanelButton]

func _ready() -> void:
	_setup(self)
	
	Utils.connect_to_signal(close_prompt, prompt_yes.pressed)
	Utils.connect_to_signal(close_prompt, prompt_no.pressed)
	
	to_load_section.pressed.connect(func(): change_to_state("LOAD_STATE"))
	to_save_section.pressed.connect(func(): change_to_state("SAVE_STATE"))
	

func close_prompt() -> void: prompt_window.visible = false

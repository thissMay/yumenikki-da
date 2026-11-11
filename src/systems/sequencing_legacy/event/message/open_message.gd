class_name EVN_OpenMessage
extends Event

enum type {MESSAGE, DIALOGUE, PROMPT}

@export var message_type: type
@export_multiline var texts: PackedStringArray

@export_group("Overrides.")
@export var sound_override: AudioStream = null
@export var font_override: Font
@export var font_colour_override: Color = Color.WHITE
@export var speed_override: float = 1
@export_subgroup("Panel.")
@export var hide_panel: bool = false
@export var panel_style_override: StyleBoxTexture = MessageDisplay.DEFAULT_PANEL_STYLE

@export_group("Prompt Exclusive")
@export var prompt_options: Dictionary[StringName, Sequence] = {}
@export var normal_colour: 		Color = Color(1, 1, 1)
@export var hover_colour: 		Color = Color(1, 0.0, 0.23)
@export var disabled_colour: 	Color = Color(0.35, 0.35, 0.45) 
@export var press_colour: 		Color = Color(1, 1, 0)

# - event implementations
func _execute() -> void: 
	var type_to_display: MessageDisplay
	
	match message_type:
		type.MESSAGE: 	type_to_display 	= MessageDisplayManager.instance.message_display
		type.DIALOGUE: 	type_to_display		= MessageDisplayManager.instance.dialogue_display
		type.PROMPT:  	
			type_to_display 	= MessageDisplayManager.instance.prompt_display  
			type_to_display.set_options(prompt_options, normal_colour, hover_colour, disabled_colour, press_colour)
			Utils.connect_to_signal(prioritize_option_sequence, type_to_display.option_chosen)
		
	if hide_panel:  type_to_display.self_modulate.a = 0
	else:			type_to_display.self_modulate.a = 1
	
	MessageDisplayManager.instance.open_message_display(
		type_to_display, 
		texts,
		sound_override,
		speed_override,
		font_colour_override,
		panel_style_override)
		
	await type_to_display.finished
	
func prioritize_option_sequence(_seq: Sequence) -> void:
	next = _seq
	
func _validate() -> bool:
	return !texts.is_empty()

# - misc.

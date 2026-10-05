extends Sequence

enum MODE {ENTER, EXIT, BOTH}
var state: LegacyState
@export var emit_mode: MODE

func _ready() -> void:
	super()
	state = get_parent()
	
	if state != null and state is LegacyState:
		match emit_mode:
			MODE.ENTER:
				state.entered.connect(func(): SequencerManager.invoke(self))
			MODE.EXIT: 
				state.exited.connect(func(): SequencerManager.invoke(self))
			_:
				state.entered.connect(func(): SequencerManager.invoke(self))
				state.exited.connect(func(): SequencerManager.invoke(self))
				
	process_mode = Node.PROCESS_MODE_DISABLED	

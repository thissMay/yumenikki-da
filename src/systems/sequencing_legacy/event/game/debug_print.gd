extends Event

@export var message: String
func _execute() -> void: 
	print(">>> %s" % message)

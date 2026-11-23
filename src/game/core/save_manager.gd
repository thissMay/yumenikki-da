class_name SaveManager
extends GameDependency

static var TEMPLATE_DATA := {
	"version" 	: "DEFAULT",
	"game" 		: 
		{
		"completed" 	: false,
		"read_warning" 	: false,
		"time_played" 	: 00,
		},
	"global" 	: 
		{
		"flags" : {}
		},
	"player" 	: {},
	"scene" 	: {}}

static var time_elapsed: float
static var data		: Dictionary
static var curr_data: Dictionary

static func get_time_elapsed_in_HMS() -> Dictionary:
	return {
		"hours" 	: floori(fmod(time_elapsed / 3600, 24)),
		"minutes" 	: floori(fmod(time_elapsed, 3600) / 60),
		"seconds" 	: floori(fmod(fmod(time_elapsed, 3600), 60))
	}

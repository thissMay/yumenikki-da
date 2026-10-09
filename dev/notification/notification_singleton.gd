extends Node

const MAX_NOTIFS: int = 5
const NOTIF_INSTANCE_PATH: String = ""

var pool: Stack
var active_pool: Stack

var notif_queue: Queue

func _ready() -> void:
	pool = Stack.new(MAX_NOTIFS)
	active_pool = Stack.new(MAX_NOTIFS)
	notif_queue = Queue.new();

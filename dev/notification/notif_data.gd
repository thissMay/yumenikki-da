class_name DevNotifData
extends Node

const ICON_ALERT: Texture2D = preload("res://dev/notification/icons/notif_alert.png")
const ICON_DANGER: Texture2D = preload("res://dev/notification/icons/notif_danger.png")
const ICON_INFO: Texture2D = preload("res://dev/notification/icons/notif_info.png")

var icon: Texture2D
var text: String

func _init(_text: String, _icon: Texture2D) -> void:
	self.text = _text if _text.length() >= 0  else "no text."
	self.icon = _icon if _icon != null else ICON_ALERT
	

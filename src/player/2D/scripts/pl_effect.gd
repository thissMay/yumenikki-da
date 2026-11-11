class_name PLEffect
extends Resource

@export_group("Action Overrides")

const EMOTE_PATH := &"emote/"
const ACTION_PATH := &"action/"

@export_group("Information")
@export var name: String = ""
@export var icon: Texture2D

@export var skip_equip_animation: bool 		= false
@export var skip_deequip_animation: bool 	= false

@export_group("Attributes")
@export var variables: SBVariables 	= preload("res://src/player/2D/effects/_none/_stats.tres")
@export var behaviour: PLBehaviour	= preload("res://src/player/2D/effects/_none/_behaviour.tres")
@export_file("*.png") var sprite_override: String 	= ("res://src/player/2D/display/default/sprite.png")
@export_file("*.tres") var emote: String 			= ("res://src/player/2D/emotes/sit_down.tres")
	

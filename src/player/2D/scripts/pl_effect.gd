class_name PLEffect
extends Resource

@export_group("Action Overrides")

@export var action: PLAction

const EMOTE_PATH := &"emote/"
const ACTION_PATH := &"action/"

@export_group("Information")
@export var name: String = ""
@export var icon: Texture2D

@export var skip_equip_animation: bool 		= false
@export var skip_deequip_animation: bool 	= false

@export_group("Attributes")
@export var variables: SBVariables 	= preload("res://src/player/2D/madotsuki/effects/_none/_stats.tres")
@export var behaviour: PLBehaviour	= preload("res://src/player/2D/madotsuki/effects/_none/_behaviour.tres")
@export_file("*.tres") var sprite_override: String 	= ("res://src/player/2D/madotsuki/display/no_effect.tres")
@export_file("*.tres") var emote: String 			= ("res://src/player/2D/madotsuki/emotes/sit_down.tres")
	
@export_file("*.tscn") var player_component_prefab: String

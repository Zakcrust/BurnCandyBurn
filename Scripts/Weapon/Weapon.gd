extends Node

class_name Weapon

var weapon_name : String = ""
var weapon_image_path : String = ""
var weapon_damage : float = 0
var weapon_defense : float = 0

func _init(wp_name = "", wp_path = "", wp_damage = "", wp_damage = 0.0, wp_defense = 0.0):
	weapon_name = wp_name
	weapon_image_path = wp_path
	weapon_damage = wp_damage
	weapon_defense = wp_defense
	
func get_weapon_name() -> String:
	return weapon_name
	
func set_image_path(value : String) -> void:
	weapon_image_path = value
	
func get_image_path() -> String:
	return weapon_image_path
	
func set_weapon_damage(value : float) -> void:
	weapon_damage = value

func get_weapon_damage() -> float:
	return weapon_damage

func set_weapon_defense(value : float) -> void:
	weapon_defense = value
	
func get_weapon_defense() -> float:
	return weapon_defense

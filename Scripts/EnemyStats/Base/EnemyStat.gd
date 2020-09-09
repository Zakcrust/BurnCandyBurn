extends KinematicBody2D

class_name Enemy

var health : int = 0 setget set_health,get_health
var points : int = 0 setget set_points,get_points

func _init(init_health = 0, init_points = 0):
	health = init_health
	points = init_points

func get_health() -> int:
	return health
	
func set_health(value : int) -> void:
	health = value
	if health <= 0:
		queue_free()

func get_points() -> int:
	return points
	
func set_points(value : int) -> void:
	points = value

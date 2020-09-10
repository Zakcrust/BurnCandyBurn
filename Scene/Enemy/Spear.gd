extends Area2D

var velocity : Vector2
var speed : float = 600
var GRAVITY : float = 10

var direction : Vector2


func to_left() -> void:
	direction = Vector2.LEFT
	$spear.scale.x = 1

func to_right() -> void:
	direction = Vector2.RIGHT
	$spear.scale.x = -1


func _process(delta):
	position += direction * speed * delta
	position.y += GRAVITY * delta


func _on_Spear_body_entered(body):
	if body is Player:
		body.hit()

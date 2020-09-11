extends Area2D


var speed : float = 800

var direction : Vector2

func to_left() -> void:
	direction = Vector2.LEFT
	$shockwave.scale.x = -1

func to_right() -> void:
	direction = Vector2.RIGHT
	$shockwave.scale.x = 1

func _process(delta):
	position += direction * speed * delta


func _on_Timer_timeout():
	queue_free()


func _on_ShieldShockwave_body_entered(body):
	if body is Player:
		body.hit()

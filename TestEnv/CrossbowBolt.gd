extends Node2D


var bullet_speed : float = -500
var bullet_rotation : float

func set_bullet_rotation(value : float) -> void:
	bullet_rotation = value
	rotation = value

func _process(delta):
	position += Vector2(bullet_speed, position.y).rotated(bullet_rotation) * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_CrossbowBolt_body_entered(body):
	if body is Player:
		body.hit()
		queue_free()

extends Area2D


class_name Bolt

var bullet_speed : float = -350
var bullet_rotation : float


func set_bullet_rotation(value : float) -> void:
	bullet_rotation = value
	rotation = value

func _process(delta):
	position += transform.x * bullet_speed * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_CrossbowBolt_body_entered(body):
	if body is Player:
		body.hit()
		queue_free()

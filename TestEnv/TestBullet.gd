extends Node2D


var bullet_speed : float = 900
var bullet_rotation : float

func set_bullet_rotation(value : float) -> void:
	bullet_rotation = value

func _process(delta):
	position += transform.x * bullet_speed * delta
		

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Bullet_body_entered(body):
	if body is Enemy:
		body.health = body.health - 1
		queue_free()

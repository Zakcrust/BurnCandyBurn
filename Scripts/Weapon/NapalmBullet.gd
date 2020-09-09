extends Area2D

var bullet_speed : float = 450
var bullet_rotation : float
var GRAVITY : float = 100

func set_bullet_rotation(value : float) -> void:
	bullet_rotation = value

func _process(delta):
	position     += transform.x * bullet_speed * delta
	position     +=  (transform.y * GRAVITY * delta).rotated(bullet_rotation)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_NapalmBullet_body_entered(body):
	if body is TileMap:
		queue_free()

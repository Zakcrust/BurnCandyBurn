extends Node2D


var bullet_speed : float = 900
var bullet_rotation : float

var hit_particle : PackedScene = load("res://Scene/Weapon/HitParticles.tscn")

func set_bullet_rotation(value : float) -> void:
	bullet_rotation = value

func _process(delta):
	position += transform.x * bullet_speed * delta
		

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Bullet_body_entered(body):
	if body is Enemy:
		body.current_health = body.current_health - 1
		var _hit_particle = hit_particle.instance()
		_hit_particle.position = global_position
		get_parent().add_child(_hit_particle)
		queue_free()
	elif body is Bolt:
		body.queue_free()
		queue_free()

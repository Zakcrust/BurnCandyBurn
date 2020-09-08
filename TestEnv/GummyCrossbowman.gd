extends EnemyStat

var velocity : Vector2 = Vector2()
var GRAVITY : float = 1000
var ply : KinematicBody2D
var attack_cooldown : bool = false
var state = IDLE

onready var crossbow_bolt : PackedScene = load("res://TestEnv/CrossbowBolt.tscn")

signal send_bullet(obj, obj_position, obj_rotation)

enum {
	IDLE,
	ATTACKING
}


func _init().(4, 0):
	pass

func _process(delta):
	velocity.x = 0
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)

	match(state):
		IDLE:
			pass
		ATTACKING:
			_aim_at_player()
			_face_to_player()
			if not attack_cooldown:
				_attack_player()

func _aim_at_player():
	$Body/Hand.rotation = (global_position - ply.global_position).angle()
#	$Body/Hand.look_at(ply.position)


func _attack_player():
	attack_cooldown = true
	$AttackCooldown.start()
	var new_bolt = crossbow_bolt.instance()
	new_bolt.position = $Body/Hand/BulletSpawnPos.global_position
	new_bolt.set_bullet_rotation($Body/Hand.rotation)
	emit_signal("send_bullet", new_bolt, $Body/Hand/BulletSpawnPos.global_position, $Body/Hand.global_rotation)
	

func _on_PlayerDetector_body_entered(body):
	if body is Player:
		ply = body
		state = ATTACKING
		_face_to_player()

func _face_to_player():
	if ply.global_position.x < global_position.x:
		$Body.flip_h = false
		$Body/Hand.flip_v = false
	else:
		$Body.flip_h = true
		$Body/Hand.flip_v = true
		


func _on_AttackCooldown_timeout():
	attack_cooldown = false


func _on_Player_send_bullet(obj):
	pass # Replace with function body.

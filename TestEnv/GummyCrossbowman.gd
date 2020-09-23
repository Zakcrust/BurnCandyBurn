extends Enemy

var velocity : Vector2 = Vector2()
var GRAVITY : float = 1000
var ply : KinematicBody2D
var attack_cooldown : bool = false
var state = IDLE
var dead : bool = false
var current_health : int setget set_current_health, get_current_health

var rand : RandomNumberGenerator


onready var crossbow_bolt : PackedScene = load("res://TestEnv/CrossbowBolt.tscn")

signal send_bullet(obj, obj_position, obj_rotation)

enum {
	IDLE,
	ATTACKING,
	DEATH
}


func _init().(2, 0):
	current_health = health

func _ready():
	$Body.play("idle")
	rand = RandomNumberGenerator.new()
	attack_cooldown = true
	$AttackCooldown.set_wait_time(rand.randf_range(1,2))
	$AttackCooldown.start()


func set_current_health(value :int) -> void:
	current_health = value
	if current_health <= 0:
		get_parent().report_dead()
		$Body/Hand.visible = false
		$Collider.scale.y = 0.3
		$Body.play("death")
		state = DEATH
		dead = true
#		$Collider.call_deferred("set_disabled", true)

func get_current_health() -> int:
	return current_health



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
			if not attack_cooldown and not dead:
				_attack_player()

func _aim_at_player():
	$Body/Hand.rotation = ($Body/Hand.global_position - ply.global_position).angle()
#	$Body/Hand/ShoulderAim.look_at(ply.position)
#	$Body/Hand.look_at(ply.position)


func _attack_player():
	attack_cooldown = true
	$AttackCooldown.start()
	var new_bolt = crossbow_bolt.instance()
	new_bolt.position = $Body/Hand/BulletSpawnPos.global_position
	new_bolt.transform = $Body/Hand/BulletSpawnPos.global_transform
#	new_bolt.set_bullet_rotation($Body/Hand.global_rotation)

	get_tree().get_root().get_node("Stage1/BulletPool").add_child(new_bolt)
#	emit_signal("send_bullet", new_bolt, $Body/Hand/BulletSpawnPos.global_position, $Body/Hand.global_rotation)
	

func _on_PlayerDetector_body_entered(body):
	if body is Player:
		ply = body
		state = ATTACKING
		_face_to_player()
		$PlayerDetector/CollisionShape2D.call_deferred("set_disabled", true)

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

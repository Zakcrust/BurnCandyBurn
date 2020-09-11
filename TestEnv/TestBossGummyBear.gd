extends Enemy



var velocity : Vector2 = Vector2()
var GRAVITY : float = 1000
var speed : float = 100
var dash : float = 450
var player : KinematicBody2D

var dash_target : Vector2 = Vector2()

var attack_counter : int = 0
var attacking : bool = false

var current_health : int = 0 setget set_current_health, get_current_health

var shockwave_scene : PackedScene = load("res://Scene/Enemy/ShieldShockwave.tscn")
var spear_scene : PackedScene = load("res://Scene/Enemy/Spear.tscn")


signal add_shockwave(obj, obj_position)
signal add_spear(obj, obj_position)

enum {
	IDLE
	MOVE,
	DASH,
	SLAM,
	ATTACK,
	THROWSPEAR
}

var state = IDLE

func _init().(60, 0):
	pass
	
func set_current_health(value : int) -> void:
	current_health = value
	if current_health <= 0:
		queue_free()


func get_current_health() -> int:
	return current_health


func _process(delta):
	velocity.x = 0
	velocity.y += GRAVITY * delta
	
	match(state):
		IDLE:
			pass
		MOVE:
			_check_player_position()
			velocity.x = speed
			$Body.play("move_spear")
		DASH:
			position = position.linear_interpolate(dash_target, delta)
		ATTACK:
			pass

	velocity = move_and_slide(velocity, Vector2.UP)


func _dash_check():
	var distance_to_player : float = position.distance_to(player.position)
	if distance_to_player < 450 and is_on_floor():
		dash_target = player.position
		state = DASH
		$DashTimer.start()

func _check_player_position() -> void:
	if player.global_position.x < global_position.x:
		if speed > 0:
			speed = -speed
			$Body.scale.x = 1
	else:
		speed = abs(speed)
		$Body.scale.x = -1


func _on_PlayerDetector_body_entered(body):
	if body is Player:
		player = body
		_check_player_position()
		state = THROWSPEAR
		$Body.play("spear_throw")
		$ThrowingTimer.start()
		$PlayerDetector/CollisionShape2D.call_deferred("set_disabled", true)


func _on_DashTimer_timeout():
	state = MOVE


func _on_Body_animation_finished():
	if $Body.animation == "shield_slam":
		$SlamDelay.start()

func _on_MeleeRange_body_entered(body):
	if body is Player and state == MOVE and not attacking:
		attacking = true
		state = ATTACK
		$Body.play("attack_init")
		$AttackPropagate.start()


func _on_AttackPropagate_timeout():
	attack_counter += 1
	$Body.play("attack")
	$AttackDelay.start()
	_check_attack_count()


func _check_attack_count() -> void:
	if attack_counter >= 3:
		attack_counter = 0
		attacking = true
		$ToSlam.start()


func _on_AttackDelay_timeout():
	attacking = false
	state = MOVE


func _on_ToSlam_timeout():
	state = SLAM
	attacking = true
	$Body.play("shield_slam")
	$ShockWaveTimer.start()

func _on_SlamDelay_timeout():
	state = MOVE
	attacking = false


func _on_ShockWaveTimer_timeout():
	var left_shockwave = shockwave_scene.instance()
	left_shockwave.to_left()
	var right_shockwave = shockwave_scene.instance()
	right_shockwave.to_right()
	left_shockwave.position = $LeftWave.global_position
	right_shockwave.position = $RightWave.global_position
	get_tree().get_root().get_node("Stage1/BulletPool").add_child(left_shockwave)
	get_tree().get_root().get_node("Stage1/BulletPool").add_child(right_shockwave)
#	emit_signal("add_shockwave", left_shockwave, $LeftWave.global_position)
#	emit_signal("add_shockwave", right_shockwave, $RightWave.global_position)


func _on_ThrowingTimer_timeout():
	var new_spear = spear_scene.instance()
	if $Body.scale.x == -1:
		new_spear.to_right()
	else:
		new_spear.to_left()
	new_spear.position = $Body/SpearPosition.global_position
	get_tree().get_root().get_node("Stage1/BulletPool").add_child(new_spear)
#	emit_signal("add_spear", new_spear, $Body/SpearPosition.global_position)
	$ThrowingDelay.start()


func _on_ThrowingDelay_timeout():
	state = MOVE

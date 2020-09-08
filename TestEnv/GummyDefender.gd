extends EnemyStat


var speed : float = 200
var velocity : Vector2 = Vector2()
var GRAVITY : float = 1000
var dash_speed : float = 400
var dash_direction : Vector2
var state = IDLE
var ply : KinematicBody2D


enum {
	IDLE,
	MOVE,
	INIT_DASH
	DASH,
	DEATH
}


func _init().(2, 0):
	pass

func _process(delta):
	velocity.x = 0
	match(state):
		IDLE:
			$Body.play("idle")
		MOVE:
			velocity.x += speed
			$Body.play("move")
		DASH:
			position = lerp(position, position + (dash_direction * dash_speed), delta)
	velocity.y += GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _check_player_position() -> void:
	print("player position : %s" % ply.global_position.x)
	print("position : %s" % global_position.x)
	if ply.global_position.x > global_position.x:
		$Body.scale.x = -1
		print(scale.x)
		speed = abs(speed)
		$Body.play("move")
	else:
		$Body.scale.x = 1
		print(scale.x)
		speed = -1 * speed
		$Body.play("move")


func _on_VisibilityNotifier2D_screen_exited():
	state = IDLE
	_check_player_position()
	$IdleTimer.start()



func _on_IdleTimer_timeout():
	state = MOVE


func _on_PlayerDetector_body_entered(body):
	if body is Player and ply != body:
		ply = body
		_check_player_position()
		state = MOVE


func _on_DashPoint_body_entered(body):
	if state == IDLE:
		return
	if body is Player:
		if $Body.scale.x > 0:
			dash_direction = Vector2.LEFT
		else:
			dash_direction = Vector2.RIGHT
	$Body.play("init_dash")
	state = INIT_DASH
	yield(get_tree().create_timer(0.6),"timeout")
	$Body.play("dash")
	state = DASH
	$DashTimer.start()


func _on_DashTimer_timeout():
	state = IDLE
	$DashCoolDown.start()


func _on_DashCoolDown_timeout():
	state = MOVE

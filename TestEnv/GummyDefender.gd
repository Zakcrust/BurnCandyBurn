extends Enemy


var speed : float = 200
var velocity : Vector2 = Vector2()
var GRAVITY : float = 1000
var dash_speed : float = 400
var dash_direction : Vector2
var state = IDLE
var ply : KinematicBody2D

var current_health : int setget set_current_health, get_current_health

var dead : bool = false

enum {
	IDLE,
	MOVE,
	INIT_DASH
	DASH,
	DEATH
}


func _init().(4, 0):
	current_health = health

func is_dead() -> bool:
	return dead


func set_current_health(value : int) -> void:
	if dead:
		return
	current_health = value
	if current_health <= 0:
		dead = true
		get_parent().report_dead()
		$Body.play("death")
		state = DEATH
#		set_process(false)
		$Collider.scale.y = 0.3
		$Body/DashPoint/DashCollider.call_deferred("set_disabled", true)
#		$Collider.call_deferred("set_disabled", true)
		$DashTimer.stop()
		$DashCoolDown.stop()
		$DashInit.stop()
		$Body/SpearPoint.monitoring = false
		$Body/DashPoint.monitoring = false
		

func get_current_health() -> int:
	return current_health

func _ready():
	$IdleTimer.autostart = true
	$Body/SpearPoint/SpearCollider.disabled = true

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
	if ply.global_position.x > global_position.x:
		$Body.scale.x = -1
		speed = abs(speed)
		$Body.play("move")
	else:
		$Body.scale.x = 1
		speed = -1 * speed
		$Body.play("move")


func _on_VisibilityNotifier2D_screen_exited():
	state = IDLE
	$IdleTimer.start()


func _on_IdleTimer_timeout():
	state = MOVE
	print("turning back!")
	_check_player_position()


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
		$Body/DashPoint/DashCollider.call_deferred("set_disabled", true)
		$DashInit.start()


func _on_DashTimer_timeout():
	$Body/SpearPoint/SpearCollider.call_deferred("set_disabled", true)
	state = IDLE
	$DashCoolDown.start()


func _on_DashCoolDown_timeout():
	state = MOVE
	$Body/DashPoint/DashCollider.call_deferred("set_disabled", false)


func _on_DashInit_timeout():
	$Body/SpearPoint/SpearCollider.call_deferred("set_disabled", false)
	$Body.play("dash")
	state = DASH
	$DashTimer.start()


func _on_SpearPoint_body_entered(body):
	if body is Player and not body.is_dying():
		print("hit player")
		body.hit()
	

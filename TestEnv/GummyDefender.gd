extends KinematicBody2D


var speed : float = 200
var velocity : Vector2 = Vector2()
var GRAVITY : float = 1000

var state = IDLE
var ply : KinematicBody2D


enum {
	IDLE,
	MOVE
}




func _process(delta):
	velocity.x = 0
	match(state):
		IDLE:
			pass
		MOVE:
			velocity.x += speed
	velocity.y += GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _check_player_position() -> void:
	if ply.global_position.x > global_position.x:
		speed = abs(speed)
		scale.x = 1
	else:
		speed = -speed
		scale.x = -1
		


func _on_VisibilityNotifier2D_screen_exited():
	state = IDLE
	_check_player_position()
	$IdleTimer.start()


func _on_IdleTimer_timeout():
	state = MOVE


func _on_Spear_body_entered(body):
	if body == ply:
		ply.queue_free()


func _on_PlayerDetector_body_entered(body):
	if body is Player:
		ply = body
		_check_player_position()
		state = MOVE

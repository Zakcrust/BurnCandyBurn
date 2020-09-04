extends KinematicBody2D



var velocity : Vector2 = Vector2()
var GRAVITY : float = 1000
var speed : float = 300
var dash : float = 450
var player : KinematicBody2D

var dash_target : Vector2 = Vector2()

enum {
	MOVE,
	DASH
}

var state = MOVE

func _process(delta):
	velocity.x = 0
	velocity.y += GRAVITY * delta
	
	match(state):
		MOVE:
			_dash_check()
		DASH:
			position = position.linear_interpolate(dash_target, delta)

	velocity = move_and_slide(velocity, Vector2.UP)


func _dash_check():
	var distance_to_player : float = position.distance_to(player.position)
	if distance_to_player < 450 and is_on_floor():
		dash_target = player.position
		state = DASH
		$DashTimer.start()


func _on_PlayerDetector_body_entered(body):
	if body is Player:
		player = body


func _on_DashTimer_timeout():
	state = MOVE

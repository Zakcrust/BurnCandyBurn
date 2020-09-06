extends KinematicBody2D

class_name Player

export (PackedScene) var bullet

var velocity : Vector2 = Vector2()

var GRAVITY : float = 1000

var speed : float = 300
var jump_speed : float = 500
var dash_speed : float = 800
var rotation_to_mouse : float

var weapon_list = {
	"flame_pistol" : load("res://Scripts/Weapon/FlamePistol.gd").new(),
	"flamethrower" : load("res://Scripts/Weapon/Flamethrower.gd").new(),
	"napalm" : load("res://Scripts/Weapon/Napalm.gd").new(),
#	"shield" : load("").new()
}


enum {
	MOVE,
	DASH,
	SHIELD,
	FLAME_PISTOL,
	FLAMETHROWER,
	NAPALM
}




signal send_bullet(obj, obj_position, obj_rotation)

var player_state = MOVE
var weapon_state = FLAME_PISTOL
var dash_direction : Vector2
var is_dash_cooldown : bool = false

func _process(delta):
	_player_input(delta)

func _player_input(delta):
	velocity.x = 0
	match(player_state):
		MOVE:
			if Input.is_action_pressed("move_left"):
				velocity.x = -speed
			if Input.is_action_pressed("move_right"):
				velocity.x = speed
			if Input.is_action_pressed("jump") and is_on_floor():
				velocity.y = -jump_speed
			if Input.is_action_just_pressed("dash") and !is_dash_cooldown:
				$Body.play("dash")
				player_state = DASH
				if velocity.x < 0:
					dash_direction = Vector2.LEFT
					$Body.scale.x = -1
#					$Body/Hand.flip_v = true
#					$Body.flip_h = true
				else:
					dash_direction = Vector2.RIGHT
					$Body.scale.x = 1
#					$Body/Hand.flip_v = false
#					$Body.flip_h = false
				$DashTimer.start()
				return
			if not is_on_floor():
				$Body.play("jump")
			else:
				if velocity.x != 0:
					$Body.play("walk")
				else:
					$Body.play("idle")
			_hand_control(delta)
			_gun_control(delta)
		DASH:
			position = lerp(position, position + (dash_direction * dash_speed), delta)
			return
			
					
	velocity.y += GRAVITY * delta
	velocity.y = clamp(velocity.y, -jump_speed, GRAVITY)
	velocity = move_and_slide(velocity, Vector2.UP)
	


func _hand_control(_delta):
	var mouse_position : Vector2 = get_global_mouse_position()
	$Body/Hand.look_at(mouse_position)
	rotation_to_mouse = (global_position - mouse_position).angle()
	
	if rotation_to_mouse > -0.5 and rotation_to_mouse < 0.5:
		$Body.scale.x = -1
#		if not $Body/Hand.flip_v:
#			$Body/Hand.flip_v = true
#		if not $Body.flip_h:
#			$Body.flip_h = true
	else:
		$Body.scale.x = 1
#		$Body/Hand.flip_v = false
#		$Body.flip_h = false
	
func _gun_control(_delta):
	if Input.is_action_just_pressed("fire"):
		var new_bullet = bullet.instance()
		if $Body.scale.x == 1:
			emit_signal("send_bullet", new_bullet, $Body/Hand/BulletSpawner.global_position, $Body/Hand.global_rotation)
		else:
			emit_signal("send_bullet", new_bullet, $Body/Hand/BulletSpawner.global_position, -$Body/Hand.global_rotation)

func _weapon_slot_control():
	if Input.is_action_just_pressed("flame_pistol"):
		pass



func _on_DashTimer_timeout():
	player_state = MOVE
	is_dash_cooldown = true
	$DashCooldown.start()


func _on_HurtBox_body_entered(body):
	if body is TileMap:
		velocity.x = 0
		player_state = MOVE


func _on_DashCooldown_timeout():
	is_dash_cooldown = false





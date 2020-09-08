extends Node2D


func _ready():
	$ToRoom2/CollisionShape2D.disabled = true
	$ToRoom3/CollisionShape2D.disabled = true


func _on_ToRoom2_body_entered(body):
	if body is Player:
		$Camera2D.limit_right = 1024*2
		$Camera2D.offset_h = 50
		body.set_min_x_pos(1024)
		body.set_max_x_pos(1024*2)


func _on_ToRoom3_body_entered(body):
	if body.name is Player:
		$Camera2D.limit_right = 1024*3
		$Camera2D.offset_h = 50
		body.set_min_x_pos(1024*2)
		body.set_max_x_pos(1024*3)

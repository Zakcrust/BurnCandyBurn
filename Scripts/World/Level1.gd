extends Node2D

var current_room : int = 1


func _ready():
	$ToRoom2/CollisionShape2D.disabled = true
	$ToRoom3/Collider.disabled = true
	$Room1Spawner.start_spawners()

func _check_room() -> void:
	match(current_room):
		1:
			$ToRoom2/CollisionShape2D.disabled = true
			$ToRoom3/CollisionShape2D.disabled = true
		2:
			$ToRoom2/CollisionShape2D.disabled = false
			print("Room 2...")
		3:
			print("Room 3...")
			$ToRoom3/Collider.disabled = false


func _on_ToRoom2_body_entered(body):
	if body is Player:
		$Camera2D.limit_right = 1024*2
		$Camera2D.offset_h = 50
		body.set_min_x_pos(1024)
		body.set_max_x_pos(1024*2)
		$ToRoom2/CollisionShape2D.call_deferred("set_disabled", true)
		$Room2Spawner.start_spawners()


func _on_ToRoom3_body_entered(body):
	if body is Player:
		print("colliding")
		$UI/ui/bossAppear.show()
		$Camera2D.limit_right = 1024*3
		$Camera2D.offset_h = 50
		body.set_min_x_pos(1024*2)
		body.set_max_x_pos(1024*3)
		$ToRoom3/Collider.call_deferred("set_disabled", true)
		$Room3Spawner.start_spawners()


func _on_Room1Spawner_enemies_cleared():
	current_room += 1
	print("Enemies Cleared!")
	_check_room()


func _on_Room2Spawner_enemies_cleared():
	current_room += 1
	print("Enemies Cleared!")
	_check_room()

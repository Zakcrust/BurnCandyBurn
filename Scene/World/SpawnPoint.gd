extends Node2D


export (int) var spawn_pool
export (float) var spawn_delay
export (PackedScene) var enemy_scene

var spawned_enemy : int = 0

export (int) var maximum_spawn : int = 2

var can_spawn : bool = true

signal enemy_cleared()

func _ready():
	$SpawnTimer.set_wait_time(spawn_delay)


func _process(delta):
	if (get_child_count() - 1) >= maximum_spawn:
		can_spawn = false
	else:
		can_spawn = true


func start_spawner() -> void:
	$SpawnTimer.start()
	var new_enemy = enemy_scene.instance()
#	new_enemy.global_position = global_position
	add_child(new_enemy)
	spawned_enemy += 1

func stop_spawner() -> void:
	$SpawnTimer.stop()


func _on_SpawnTimer_timeout():
	if spawned_enemy < spawn_pool and can_spawn:
		var new_enemy = enemy_scene.instance()
#		new_enemy.position = global_position
		add_child(new_enemy)
		spawned_enemy += 1
		print("spawned_enemy : %s " % spawned_enemy)
	elif spawned_enemy >= spawn_pool and get_child_count() == 1:
		$SpawnTimer.stop()
		emit_signal("enemy_cleared")
	
	

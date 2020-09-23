extends Node2D


export (int) var spawn_pool
export (float) var spawn_delay
export (PackedScene) var enemy_scene

var spawned_enemy : int = 0

export (int) var maximum_spawn : int = 2

var alive_enemy : int = 0

var can_spawn : bool = true

signal enemy_cleared()

func _ready():
	$SpawnTimer.set_wait_time(spawn_delay)


func _process(delta):
	if alive_enemy >= maximum_spawn:
		can_spawn = false
	else:
		can_spawn = true


func start_spawner() -> void:
	can_spawn = true
	spawned_enemy = 0
	$SpawnTimer.start()
	var new_enemy = enemy_scene.instance()
#	new_enemy.global_position = global_position
	add_child(new_enemy)
	spawned_enemy += 1
	alive_enemy += 1

func stop_spawner() -> void:
	$SpawnTimer.stop()

func report_dead() -> void:
	alive_enemy -= 1



func _on_SpawnTimer_timeout():
	if spawn_pool < 0:
		if can_spawn:
			var new_enemy = enemy_scene.instance()
			if new_enemy is Enemy:
				print("signal connected")
#				new_enemy.connect("send_bullet", get_tree().get_root().get_node("Stage1/BulletPool"), "send_bullet" )
	#		new_enemy.position = global_position
			add_child(new_enemy)
	if spawned_enemy < spawn_pool and can_spawn:
		var new_enemy = enemy_scene.instance()
		if new_enemy is Enemy:
			pass
#			new_enemy.connect("send_bullet", get_tree().get_root().get_node("Stage1/BulletPool"), "send_bullet" )
#		new_enemy.position = global_position
		add_child(new_enemy)
		spawned_enemy += 1
		alive_enemy += 1
		print("spawned_enemy : %s " % spawned_enemy)
	elif spawned_enemy >= spawn_pool and alive_enemy <= 0:
		$SpawnTimer.stop()
		emit_signal("enemy_cleared")
	
	

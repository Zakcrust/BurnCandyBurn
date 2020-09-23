extends Node2D


export (int) var maximum_spawn_pool
export (int) var maximum_wave


var spawned_enemy : int = 0
var wave_count : int = 0
var spawners_count : int


signal enemies_cleared()

signal update_wave_ui(wave)


func start_spawners():
	yield(get_tree().create_timer(2.0), "timeout")
	spawners_count = get_child_count()
	for child in get_children():
		child.start_spawner()
	emit_signal("update_wave_ui", maximum_wave - wave_count)


func _on_SpawnPoint_enemy_cleared():
	spawners_count -= 1
	check_active_spawner()


func _on_SpawnPoint2_enemy_cleared():
	spawners_count -= 1
	check_active_spawner()

func check_active_spawner() -> void:
	print("active spawers : %s" % spawners_count)
	if spawners_count <= 0:
		if wave_count >= maximum_wave:
			set_process(false)
			emit_signal("enemies_cleared")
			yield(get_tree().create_timer(3.0),"timeout")
			queue_free()
		else:
			spawners_count = 0
			wave_count+= 1
			start_spawners()
			emit_signal("update_wave_ui", maximum_wave - wave_count)


func _on_SpawnPoint3_enemy_cleared():
	spawners_count -= 1
	check_active_spawner()


func _on_SpawnPoint4_enemy_cleared():
	spawners_count -= 1
	check_active_spawner()


func _on_SpawnPoint5_enemy_cleared():
	spawners_count -= 1
	check_active_spawner()

extends Node2D


var hit_particle : PackedScene = load("res://Scene/Particles/BurningEnemyFLame.tscn")


func _ready():
	set_burn(false)


func set_burn(burn : bool):
	if burn:
		$Particles2D.emitting = true
	else:
		$Particles2D.emitting = false

func burn_routine() -> void:
	if $Particles2D.emitting:
		$BurnArea.monitoring = true
		yield(get_tree().create_timer(0.1),"timeout")
		$BurnArea.call_deferred("set_monitoring", false)
		$BurnTimer.start()


func _on_BurnTimer_timeout():
	burn_routine()


func _on_BurnArea_body_entered(body):
	if body is Enemy:
		body.current_health = body.current_health - 2
		var new_particle = hit_particle.instance()
#		new_particle.position = body.global_position
		if not body.has_node("res://Scene/Particles/BurningEnemyFLame.tscn"):
			print("add burning flame")
			body.add_child(new_particle)

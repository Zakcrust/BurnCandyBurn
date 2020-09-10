extends Node2D

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

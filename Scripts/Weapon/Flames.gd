extends Node2D

func set_burn(burn : bool):
	if burn:
		$Particles2D.emitting = true
	else:
		$Particles2D.emitting = false

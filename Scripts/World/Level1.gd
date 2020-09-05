extends Node2D


func _ready():
	pass

func _on_nyobaPindah_body_entered(body):
	if body.name == "Player":
		
		$Camera2D.limit_right = 1024*2
		$Camera2D.offset_h = 50


func _on_nyobaPindah2_body_entered(body):
	if body.name == "Player":
		
		$Camera2D.limit_right = 1024*3
		$Camera2D.offset_h = 50

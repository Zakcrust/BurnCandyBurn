extends Control


func _ready():
	pass


func _on_back_pressed():
	get_tree().change_scene("res://Scene/Menu/mainMenu.tscn")

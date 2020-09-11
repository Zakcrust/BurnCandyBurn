extends Control


func _ready():
	MusicManager.play_bgm(MusicManager.sounds["bgm"]["game_play"])


func _on_start_pressed():
	pass # Replace with function body.


func _on_ext_pressed():
	get_tree().quit()


func _on_setting_pressed():
	get_tree().change_scene("res://Scene/Menu/credits.tscn")

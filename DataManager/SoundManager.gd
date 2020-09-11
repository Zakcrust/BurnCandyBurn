extends Node

var sounds : Dictionary = {
	'bgm' : {
		"game_play" : "res://Assets/sounds/bgm/I'm a scarab beetle!.ogg"
	},
	
	'sfx' : {
		"player_hit" : "res://Assets/sounds/sfx/player_hit.ogg",
		"game_win" : "res://Assets/sounds/sfx/game_win.ogg",
		"game_lose" : "res://Assets/sounds/sfx/game_lose.ogg",
		"flame_thrower" : "res://Assets/sounds/sfx/flame_thrower.ogg",
		"flamer_gun" : "res://Assets/sounds/sfx/flamer_gun.ogg",
		"enemies_hit" : "res://Assets/sounds/sfx/enemies_hit.ogg",
		"enemies_death" : "res://Assets/sounds/sfx/enemies_death.ogg"
	}
}

func _ready():
	pass

func play_bgm(path):
	$bgm.stream = load(path)
	$bgm.play()

func play_sfx(path):
	$sfx.stream = load(path)
	$sfx.play()

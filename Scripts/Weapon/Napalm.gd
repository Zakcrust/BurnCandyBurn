extends Weapon

var bullet_path : String = "res://TestEnv/TestBullet.tscn"

var bullet : PackedScene = load(bullet_path)

func _init().("napalm", "res://Assets/Player/Napalm/napalm.tres", 10, 0):
	pass

func get_bullet_path() -> String:
	return bullet_path

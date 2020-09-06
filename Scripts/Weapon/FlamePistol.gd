extends Weapon

var bullet_path : String = "res://TestEnv/TestBullet.tscn"

var bullet : PackedScene = load(bullet_path)

func _init().("flame_pistol", "res://Assets/Player/FlamePistol/flame_pistol.tres", 1, 0):
	pass

func get_bullet_path() -> String:
	return bullet_path

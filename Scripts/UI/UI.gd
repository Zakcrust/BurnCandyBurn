extends CanvasLayer

var minute : int = 0
var second : int = 0

onready var lives_ui : Array = $ui/hp.get_children()

signal finish_game(status, game_time)

var flamethrower_ui_state


func _ready():
	$ui/time/time.text = "00:00"
	flamethrower_ui_state = $ui/flamethrower/AnimState.get("parameters/playback")
	
func _process(delta):
	$ui/time/time.text = "%02d:%02d" % [minute, second]
	if second >= 60 :
		second = 0
		minute+=1

func set_active_weapon(weapon : String) -> void:
	$ui/flamepistol/border.visible = false
	$ui/flamethrower/border.visible = false
	match weapon:
		"flame_pistol":
			$ui/flamepistol/border.visible = true
		"flamethrower":
			$ui/flamethrower/border.visible = true
			$ui/flamethrower/border/Anim.stop()
			$ui/flamethrower/border/Anim.play("idle")


func _on_Timer_timeout():
	second += 1


func _on_pause_pressed():
	$pause.visible = true
	get_tree().paused = true
	


func _on_resume_pressed():
	$pause.visible = false
	get_tree().paused = false


func _on_exit_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://Scene/Menu/mainMenu.tscn")

func set_hp_bar(percent : float) -> void:
	$ui/bossAppear/bosshp/bg/TextureProgress.value = percent


func _on_Player_update_ui_weapon(weapon):
	set_active_weapon(weapon)


func _on_Player_update_lives_ui(lives):
	var live = lives_ui.pop_front()
	live.queue_free()


func _on_GummyBear_update_health_ui(percent):
	set_hp_bar(percent)


func _on_Player_update_flamethrower_ui(full):
	if full:
		print("flamethrower enabled")
		$ui/flamethrower/border.show()
		$ui/flamethrower/border/Anim.play("blip")
#		flamethrower_ui_state.travel("blip")
	else:
		$ui/flamethrower/border.hide()
		$ui/flamethrower/border/Anim.play("idle")


func _on_Player_lose():
	
	$ui.hide()
	emit_signal("finish_game", "lose", $ui/time/time.text)


func _on_GummyBear_win():
	$ui.hide()
	emit_signal("finish_game", "win", $ui/time/time.text)

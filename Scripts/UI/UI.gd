extends Control

var minute : int = 0
var second : int = 0

func _ready():
	$ui/time/time.text = "00:00"
	
func _process(delta):
	$ui/time/time.text = "%02d:%02d" % [minute, second]
	if second >= 60 :
		second = 0
		minute+=1

func _on_Timer_timeout():
	second += 1

extends Node2D

func _ready():
	pass # Replace with function body.


func _on_Player_send_bullet(obj, obj_position, obj_rotation):
	obj.position = obj_position
	obj.rotation = obj_rotation
	add_child(obj)


func _on_GummyCrossbowman_send_bullet(obj, obj_position, obj_rotation):
	obj.position = obj_position
	obj.rotation = obj_rotation
	add_child(obj)


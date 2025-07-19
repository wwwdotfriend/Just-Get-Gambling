extends Node

var mynode = preload("res://scenes/computdesktop.tscn")
var mouse_pos: Vector2
var current_pos: Vector2


func _physics_process(delta):
	if Input.is_action_just_pressed("mb"):
		mouse_pos = get_viewport().get_mouse_position()
		inst(mouse_pos)

func inst(pos):
	var instance = mynode.instantiate()
	instance.position = pos
	add_child(instance)

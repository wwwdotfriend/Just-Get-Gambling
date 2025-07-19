extends Control

@export var menu_screen: VBoxContainer
@export var open_menu_screen: VBoxContainer

func toggle_visibility(object):
	if object visible:
		object.visible = false
	else
	object.visible = true


func _on_menu_button_pressed():
	

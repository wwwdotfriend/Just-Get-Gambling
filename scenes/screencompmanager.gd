extends MarginContainer

@export var menu_screen: VBoxContainer
@export var open_menu_screen: VBoxContainer
@export var work_menu_screen: MarginContainer

func toggle_visibility(object):
	if object.visible:
		object.visible = false
	else:
		object.visible = true

func _on_togglemenu_pressed() -> void:
	toggle_visibility(menu_screen)
	toggle_visibility(open_menu_screen)
	


func _on_toggleexitmenubutton_pressed() -> void:
	toggle_visibility(work_menu_screen)

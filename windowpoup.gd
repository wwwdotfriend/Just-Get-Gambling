extends Node2D

@onready var popup = $Window

func _ready(): 
	popup.show()



func _on_window_close_requested() -> void:
	popup.hide()
	
	
	 

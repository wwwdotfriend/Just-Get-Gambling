extends Control

var machine_is_spinning: bool = false

func _on_spin_button_pressed() -> void:
	SignalBank.start_roll.emit()
	machine_is_spinning = true

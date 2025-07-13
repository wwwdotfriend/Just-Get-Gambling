extends Control

func _on_spin_button_pressed() -> void:
	SignalBank.start_roll.emit()

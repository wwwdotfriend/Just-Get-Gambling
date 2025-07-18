extends Control

var machine_is_spinning: bool = false
var reel_results = {}
var line_top = []
var line_middle = []
var line_bottom = []

func _ready() -> void:
	SignalBank.reel_finished.connect(_on_reel_finished)

func _on_spin_button_pressed() -> void:
	SignalBank.start_reel.emit()
	machine_is_spinning = true
	if machine_is_spinning:
		reel_results = {}
		line_top = []
		line_middle = []
		line_bottom = []
	
func _on_reel_finished(reel_id, reel_symbols):
	machine_is_spinning = false
	reel_results[reel_id] = reel_symbols
	if reel_results.size() == 5:
		for name in reel_results:
			var symbols = reel_results[name]
			line_top.append(symbols[0])
			line_middle.append(symbols[1])
			line_bottom.append(symbols[2])
		print("Top:    ", line_top)
		print("Middle: ", line_middle)
		print ("Bottom: ", line_bottom)

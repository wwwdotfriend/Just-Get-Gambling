extends VBoxContainer

@onready var money_display = $moneyDisplay
@onready var work_display = $workDisplay


func _process(delta):
	var money = str(global.money)
	var work = str(global.work)
	update_text()

func update_text():
	money_display.text = ("MONEY: "+ str(global.money))
	work_display.text = ("WORK: " + str(global.work))
	

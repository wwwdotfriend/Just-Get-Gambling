extends Node2D

@onready var reel_sprite1: Sprite2D = $ReelSprite1
@onready var reel_sprite2: Sprite2D = $ReelSprite2

var reel_is_spinning: bool = false

var sprite2_active: bool = false

var next_threshold: int = -1134   # when the next reel_sprite should be started, last 3 symbols
var gone_threshold: int = -1260    # when the reel_sprite is out of sight
const SCROLL_SPEED = 630

const SPRITE_HEIGHT = 1260

var sprite1_tween: Tween
var sprite2_tween: Tween

func _ready() -> void:
	SignalBank.start_roll.connect(_on_start_roll)
	reel_sprite1.position = Vector2(0,0)
	reel_sprite2.position = Vector2(0,126)
	reel_is_spinning = false
	sprite2_active = false
	
func _process(_delta: float) -> void:
	if reel_is_spinning:
		if reel_sprite1.position.y <= next_threshold:
			sprite2_start()
			if reel_sprite1.position.y >= gone_threshold:
				reel_sprite1.position.y = 126
		if reel_sprite2.position.y <= next_threshold:
			sprite1_start2()
			if reel_sprite2.position.y >= gone_threshold:
				sprite2_active = false
				reel_sprite2.position.y = 126
				
	
func _on_start_roll() -> void:
	reel_is_spinning = true
	reel_sprite1.position = Vector2(0,0)
	reel_sprite2.position = Vector2(0,126)
	sprite1_start1()
	
func sprite1_start1() -> void:
	if sprite1_tween:
		sprite1_tween.kill()
	sprite1_tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	sprite1_tween.tween_property(reel_sprite1, "position", Vector2(0,-1260), 2.52).from_current()
	
func sprite1_start2() -> void:
	if sprite1_tween:
		sprite1_tween.kill()
	sprite1_tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	sprite1_tween.tween_property(reel_sprite1, "position", Vector2(0,-1260), 2.772).from_current()
	
func sprite2_start() -> void:
	if sprite2_tween:
		sprite2_tween.kill()
	sprite2_active = true
	sprite2_tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	sprite2_tween.tween_property(reel_sprite2, "position", Vector2(0,-1260), 2.772).from_current()
	
func _on_reel_button_1_button_up() -> void:
	#print("Sprite1 Position: ", reel_sprite1.position.y, " | Sprite 2 Position: ", reel_sprite2.position.y )
	if sprite1_tween:
		sprite1_tween.kill()
	if sprite2_tween:
		sprite2_tween.kill()
	reel_is_spinning = false
	var sprite1_top = reel_sprite1.position.y
	var sprite2_top = reel_sprite2.position.y
	var sprite1_bottom = sprite1_top + SPRITE_HEIGHT
	var sprite2_bottom = sprite2_top + SPRITE_HEIGHT
	var visible_sprite
	if sprite1_top < 126 and sprite1_bottom > 0:
		print("Sprite 1 visible!")
		visible_sprite = reel_sprite1
	elif sprite2_top < 126 and sprite2_bottom > 0:
		print("Sprite 2 visible!")
		visible_sprite = reel_sprite2
	else:
		print("no visible sprite found. you fucked up somewhere.")
		return
	var offset = abs(visible_sprite.position.y)
	var cell_index = round(offset / 42.0)
	var snapped_y = - (cell_index * 42)
	visible_sprite.position.y = snapped_y
	var top_index = cell_index
	var mid_index = cell_index + 1
	var bot_index = cell_index + 2
	var reel_symbols = [top_index, mid_index, bot_index]
	print(self.name, ": ", reel_symbols)

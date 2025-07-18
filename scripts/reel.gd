extends Control

@export var reel_texture: Texture2D
@onready var reel_sprite1: Sprite2D = $ReelSpriteControl/ReelSprite1
@onready var reel_sprite2: Sprite2D = $ReelSpriteControl/ReelSprite2

var reel_is_spinning: bool = false

var sprite2_active: bool = false

var next_threshold: int = -1134   # when the next reel_sprite should be started, last 3 symbols
var gone_threshold: int = -1260    # when the reel_sprite is out of sight
const SCROLL_SPEED = 630

const SPRITE_HEIGHT = 1260
const TOP_THRESHOLD = 110
const BOT_THRESHOLD = 10

var sprite1_tween: Tween
var sprite2_tween: Tween

@onready var reel_id: String = self.name

func _ready() -> void:
	reel_sprite1.texture = reel_texture
	reel_sprite2.texture = reel_texture
	SignalBank.start_reel.connect(_on_start_reel)
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
				
	
func _on_start_reel() -> void:
	if sprite1_tween:
		sprite1_tween.kill()
	if sprite2_tween:
		sprite2_tween.kill()
	reel_is_spinning = true
	reel_sprite1.position = Vector2(0,0)
	reel_sprite2.position = Vector2(0,126)
	sprite1_start1()
	
func sprite1_start1() -> void:
	var reel1_time: float = 2.52
	if sprite1_tween:
		sprite1_tween.kill()
	sprite1_tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	sprite1_tween.tween_property(reel_sprite1, "position", Vector2(0,-1260), reel1_time).from_current()
	
func sprite1_start2() -> void:
	var reel2_time: float = 2.772
	if sprite1_tween:
		sprite1_tween.kill()
	sprite1_tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	sprite1_tween.tween_property(reel_sprite1, "position", Vector2(0,-1260), reel2_time).from_current()
	
func sprite2_start() -> void:
	var reel2_time: float = 2.772
	if sprite2_tween:
		sprite2_tween.kill()
	sprite2_active = true
	sprite2_tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	sprite2_tween.tween_property(reel_sprite2, "position", Vector2(0,-1260), reel2_time).from_current()
	
func _on_reel_button_pressed() -> void:
	var sprite1_top = reel_sprite1.position.y
	var sprite2_top = reel_sprite2.position.y
	var sprite1_bottom = sprite1_top + SPRITE_HEIGHT
	var sprite2_bottom = sprite2_top + SPRITE_HEIGHT
	
	reel_is_spinning = false
	
	if sprite1_tween:
		sprite1_tween.kill()
	if sprite2_tween:
		sprite2_tween.kill()
		
	var sprite1_visible: bool = false
	var sprite2_visible: bool = false
		
	if sprite1_top < TOP_THRESHOLD and sprite1_bottom > BOT_THRESHOLD:
		sprite1_visible = true
		if sprite1_visible:
			print("Sprite 1 visible!")
	elif sprite2_top < TOP_THRESHOLD and sprite2_bottom > BOT_THRESHOLD:
		sprite2_visible = true
		if sprite2_visible:
			print("Sprite 2 visible!")
	else:
		print("no visible sprite found. this can't be happening. you idiot.")
		return
		
	if sprite1_visible and !sprite2_visible:
		var offset = abs(reel_sprite1.position.y)
		var cell_index = round(offset / 42)
		var snapped_y = - (cell_index * 42)
		reel_sprite1.position.y = snapped_y
		var reel_symbols: Array[int] = get_visible_symbols(reel_sprite1)
		SignalBank.reel_finished.emit(reel_id, reel_symbols)
	elif sprite2_visible and !sprite1_visible:
		var offset = abs(reel_sprite2.position.y)
		var cell_index = round(offset / 42)
		var snapped_y = - (cell_index * 42)
		reel_sprite2.position.y = snapped_y
		var reel_symbols: Array[int] = get_visible_symbols(reel_sprite2)
		SignalBank.reel_finished.emit(reel_id, reel_symbols)
	elif sprite1_visible and sprite2_visible:
		reel_sprite1.position.y = snap_position(reel_sprite1.position.y)
		reel_sprite2.position.y = snap_position(reel_sprite2.position.y)
		
		var visible_sprites = [reel_sprite1, reel_sprite2]
		visible_sprites.sort_custom(func(a, b): return a.position.y < b.position.y)
		
		var all_symbols = []
		for sprite in visible_sprites:
			all_symbols.append_array(get_visible_symbols(sprite))
			
		var reel_symbols = all_symbols.slice(0, 3)
		SignalBank.reel_finished.emit(reel_id, reel_symbols)
		
func snap_position(y: float) -> float:
	var offset = abs(y)
	var cell_index = int(offset / 42)
	return -cell_index * 42
	
func get_visible_symbols(sprite: Sprite2D) -> Array[int]:
	var top_y = sprite.position.y
	var offset = abs(top_y)
	var cell_index = round(offset / 42)
	var top_index = cell_index
	var mid_index = cell_index + 1
	var bot_index = cell_index + 2
	return [int(top_index) % 30, int(mid_index) % 30, int(bot_index) % 30 ]

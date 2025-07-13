extends Node2D

@onready var reel_sprite1: Sprite2D = $ReelSprite1
@onready var reel_sprite2: Sprite2D = $ReelSprite2

var is_spinning: bool = false

var sprite2_active: bool = false

var next_threshold: int = -1134   # when the next reel_sprite should be started, last 3 symbols
var gone_threshold: int = -1260    # when the reel_sprite is out of sight
const SCROLL_SPEED = 630

var sprite1_tween: Tween
var sprite2_tween: Tween


func _ready() -> void:
	SignalBank.start_roll.connect(_on_start_roll)
	reel_sprite1.position = Vector2(0,0)
	reel_sprite2.position = Vector2(0,126)
	is_spinning = false
	sprite2_active = false
	
	
func _process(delta: float) -> void:
	if is_spinning:
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
	is_spinning = true
	print(self.name, " is spinging!")
	sprite1_start1()
	
func sprite1_start1() -> void:
	if sprite1_tween:
		sprite1_tween.kill()
	sprite1_tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	sprite1_tween.tween_property(reel_sprite1, "position", Vector2(0,-1260), 2).from_current()
	
func sprite1_start2() -> void:
	if sprite1_tween:
		sprite1_tween.kill()
	sprite1_tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	sprite1_tween.tween_property(reel_sprite1, "position", Vector2(0,-1260), 2.2).from_current()
	
func sprite2_start() -> void:
	if sprite2_tween:
		sprite2_tween.kill()
	sprite2_active = true
	sprite2_tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	sprite2_tween.tween_property(reel_sprite2, "position", Vector2(0,-1260), 2.2).from_current()

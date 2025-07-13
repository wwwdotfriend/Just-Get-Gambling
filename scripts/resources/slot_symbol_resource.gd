extends Resource
class_name SlotSymbol

@export var name: String
@export var texture: Texture2D
@export var points: int
@export var type: symbol_types

enum symbol_types {
	JACKPOT,
	HIGH,
	MEDIUM,
	LOW
}

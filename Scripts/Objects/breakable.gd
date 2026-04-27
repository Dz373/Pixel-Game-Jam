extends StaticBody2D
class_name Breakable

@export var hp: int

@export var dropAmount: int
@export var drop: PackedScene
@export var sprite: Texture2D

@onready var gameManager = $"../.."
@onready var hpBar = $TextureProgressBar

func _ready() -> void:
	hpBar.max_value = hp
	hpBar.value = hp
	hpBar.visible = false
	
	if sprite:
		$Sprite2D.texture = sprite

func takeHit(amount:int):
	hp -= amount
	hpBar.value = hp
	hpBar.visible = true
	
	if hp <= 0:
		breakObject()

func breakObject():
	if drop:
		var d = drop.instantiate()
		gameManager.call_deferred("add_child", d)
		d.position = position
		d.amount = dropAmount
	
	queue_free()

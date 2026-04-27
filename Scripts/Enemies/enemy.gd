extends StaticBody2D
class_name Enemy

@export var hp: int
@export var damage: int
@export var bulletSpd: int
@export var atkSpd: float
@export var bulletNum: int
@export var shotSpd: float

@export var dropAmount: int

@export var bullet: PackedScene
@export var drop: PackedScene

var cooldown: bool
@onready var player = $"../../Player"
@onready var gameManager = $"../.."

@onready var hpBar = $TextureProgressBar

var aggro:= false:
	set(val):
		aggro = val
		set_process(val)

func _ready() -> void:
	aggro = false
	hpBar.max_value = hp
	hpBar.value = hp
	hpBar.visible = false

func _process(_delta: float) -> void:
	if not cooldown:
		cooldown = true
		
		await get_tree().create_timer(atkSpd).timeout
		
		for i in bulletNum:
			shoot()
			await  get_tree().create_timer(shotSpd).timeout
		
		cooldown = false

func shoot():
	var dir = player.position - position
	var b = bullet.instantiate()
	add_child(b)
	b.shoot(dir.normalized(), bulletSpd, damage)

func takeHit(amount: int):
	hp -= amount
	hpBar.value = hp
	hpBar.visible = true
	if hp <= 0:
		die()

func die():
	var d = drop.instantiate()
	
	gameManager.call_deferred("add_child", d)
	d.position = position
	d.amount = dropAmount
	
	call_deferred("queue_free")

func _on_aggro_range_body_entered(_body: Node2D) -> void:
	aggro = true

func _on_aggro_range_body_exited(_body: Node2D) -> void:
	aggro = false

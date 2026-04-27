extends StaticBody2D
class_name Boss

@export var hp:int
@export var atk:int
@export var atkSpd:float

@export var ammo1: PackedScene
@export var ammo2: PackedScene

@export var atkType: int
@onready var hpBar = $"../../UI/TextureProgressBar"
@onready var player = $"../../Player"

var cooldown:bool

func _ready() -> void:
	hpBar.max_value = hp
	hpBar.value = hp
	
func _process(_delta: float) -> void:
	if !cooldown:
		cooldown = true
		await get_tree().create_timer(atkSpd).timeout
		
		match atkType:
			1:
				for i in 10:
					shoot()
					await  get_tree().create_timer(0.2).timeout
				atkType=2
			2:
				for i in 10:
					bombard()
					await  get_tree().create_timer(0.2).timeout
				atkType=1
		
		
		cooldown = false
	

func shoot():
	var dir = player.position - position
	var b = ammo1.instantiate()
	add_child(b)
	b.shoot(dir.normalized(), 600, atk)

func bombard():
	#x 64 - 1408
	#y 128 - 512
	var x = (int)(randf_range(64, 1408))
	var y = (int)(randf_range(128, 512))
	var pos = Vector2(x,y)
	
	var b = ammo2.instantiate()
	$"../..".add_child(b)
	b.position = pos

func takeHit(amount:int):
	hp -= amount
	hpBar.value = hp
	
	if hp <= 0:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/Credits.tscn")

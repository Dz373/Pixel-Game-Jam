extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var roundCounter: Label = $UI/Days
@onready var coinCounter: Label = $UI/Coin

var roundNum: int:
	set(val):
		roundNum = val
		roundCounter.text = "Night: " + str(val)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	roundNum = PlayerStats.curRound
	coinCounter.text = "Coins: " + str(PlayerStats.coins)
	
	if !PlayerStats.attack:
		$UI/Abilities/Sprite2D.visible = false
	if !PlayerStats.shoot:
		$UI/Abilities/Sprite2D2.visible = false
	if !PlayerStats.dash:
		$UI/Abilities/Sprite2D3.visible = false

func nextRound() -> void:
	get_tree().change_scene_to_file("res://Scenes/UpgradeMenu.tscn")

func updateCoins(amount):
	PlayerStats.coins += amount * PlayerStats.mult
	coinCounter.text = "Coins: " + str(PlayerStats.coins)

func abilityTimer(path: String, timer: float):
	var overlay = get_node(path + "/Panel")
	overlay.visible = true
	
	await get_tree().create_timer(timer).timeout
	
	overlay.visible = false

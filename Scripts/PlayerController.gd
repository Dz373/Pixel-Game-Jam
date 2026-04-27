extends CharacterBody2D

@onready var hpBar: HBoxContainer = $"../UI/HpBar"
@onready var gameManager = $".."
@onready var animation = $AnimatedSprite2D

@export var swipeAttack: PackedScene
@export var projAttack: PackedScene

@export var speed = 100
@export var projSpeed = 500

var atkCooldown:=false
var shtCooldown:=false
var dashCooldown:=false
var input_dir

func _ready() -> void:
	speed *= PlayerStats.spd
	hpBar.createPips(PlayerStats.curHp)

func get_input():
	input_dir = Input.get_vector("left", "right", "up", "down")
	
	if input_dir == Vector2.ZERO:
		animation.play("default")
	elif input_dir.x < 0:
		animation.play("walk_left")
	elif input_dir.x > 0:
		animation.play("walk_right")
	
	velocity = input_dir * speed

func _process(delta: float) -> void:
	get_input()
	move_and_collide(velocity * delta)
	
	var mousePos = get_local_mouse_position().normalized()
	
	if PlayerStats.attack && Input.is_action_just_pressed("attack") && !atkCooldown:
		atkCooldown = true
		
		var a = swipeAttack.instantiate()
		add_child(a)
		a.rotation_degrees = rad_to_deg(mousePos.angle()) - 90
		
		gameManager.abilityTimer("UI/Abilities/Sprite2D", PlayerStats.atkSpd)

		await get_tree().create_timer(PlayerStats.atkSpd).timeout
		atkCooldown = false
	
	if PlayerStats.shoot && Input.is_action_pressed("shoot") && !shtCooldown:
		shtCooldown = true
		
		var b = projAttack.instantiate()
		gameManager.add_child(b)
		b.position = position
		b.shoot(mousePos, projSpeed, PlayerStats.atk)
		
		gameManager.abilityTimer("UI/Abilities/Sprite2D2", PlayerStats.shtSpd)
		
		await get_tree().create_timer(PlayerStats.shtSpd).timeout
		shtCooldown = false
	
	if PlayerStats.dash && Input.is_action_pressed("dash") && !dashCooldown && velocity!=Vector2.ZERO:
		dashCooldown = true
		
		move_and_collide(velocity/2)
		
		gameManager.abilityTimer("UI/Abilities/Sprite2D3", PlayerStats.dashCd)
		
		await get_tree().create_timer(PlayerStats.dashCd).timeout
		dashCooldown = false

func updateHp(amount):
	if(amount>0):
		for n in amount:
			hpBar.addPip()
	elif(amount<0):
		for n in -amount:
			hpBar.removePip()
	
	PlayerStats.curHp += amount
	if(PlayerStats.curHp <= 0):
		gameManager.call_deferred("nextRound")
		

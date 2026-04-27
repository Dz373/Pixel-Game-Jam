extends Control

@onready var coinCounter: Label = $Coins
@onready var roundCounter: Label = $Round

@onready var hpBar: HBoxContainer = $Display/HpBar
@onready var atkBar: HBoxContainer = $Display/AtkBar
@onready var spdBar: HBoxContainer = $Display/SpdBar
@onready var multBar: HBoxContainer = $Display/MultBar

@onready var attack: Button = $UpgradeList/Attack
@onready var shoot: Button = $UpgradeList/Shoot
@onready var dash: Button = $UpgradeList/Dash

@onready var atkAbility: Label = $AbilityList/Label
@onready var shotAbility: Label = $AbilityList/Label2
@onready var dashAbility: Label = $AbilityList/Label3

func _ready() -> void:
	coinCounter.text = "Coins: " + str(PlayerStats.coins)
	roundCounter.text = "Night: " + str(PlayerStats.curRound)
	
	hpBar.createPips(PlayerStats.maxHp)
	atkBar.createPips(PlayerStats.atk)
	spdBar.createPips(PlayerStats.spd*4-3)
	multBar.createPips(PlayerStats.mult)
	
	if PlayerStats.attack:
		attack.text = "Attack Cooldown"
		changeCost("UpgradeList/Attack/Label", round((3-PlayerStats.atkSpd)*2 +1) *10)
		
		if PlayerStats.atkSpd <= 1:
			attack.visible=false
		
		atkAbility.visible = true
		atkAbility.text = "Cd: " + str(PlayerStats.atkSpd) + " sec"
	
	if PlayerStats.shoot:
		shoot.text = "Shoot Cooldown"
		changeCost("UpgradeList/Shoot/Label", round((3-PlayerStats.shtSpd)*2 +1) *10)
		
		if PlayerStats.shtSpd <= 1:
			shoot.visible=false
			
		shotAbility.visible = true
		shotAbility.text = "Cd: " + str(PlayerStats.shtSpd) + " sec"
	
	if PlayerStats.dash:
		dash.text = "Dash Cooldown"
		changeCost("UpgradeList/Dash/Label", round((5-PlayerStats.dashCd)+1) *20)
		
		if PlayerStats.dashCd <= 1:
			dash.visible=false
		
		dashAbility.visible = true
		dashAbility.text = "Cd: " + str(PlayerStats.dashCd) + " sec"
	
	changeCost("UpgradeList/HpUp/Label", (PlayerStats.maxHp-1) *3)
	changeCost("UpgradeList/AtkUp/Label", (PlayerStats.atk-1) *4)
	changeCost("UpgradeList/SpdUp/Label", (int)(PlayerStats.spd*2-2) *5)
	
	get_node("UpgradeList/Mult/Label").text = str(pow(2, PlayerStats.mult))

func _on_button_button_down() -> void:
	PlayerStats.curRound += 1
	PlayerStats.curHp = PlayerStats.maxHp
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")

func changeCost(path: String, num: int):
	var cost = get_node(path)
	
	cost.text = str((int)(cost.text) + num)

func canBuy(path: String)->bool:
	var cost = get_node(path)
	if (int)(cost.text) <= PlayerStats.coins:
		PlayerStats.coins -= (int)(cost.text)
		coinCounter.text = "Coins: " + str(PlayerStats.coins)
		
		return true
	return false

func _on_hp_up_button_down() -> void:
	var path = "UpgradeList/HpUp/Label"
	if not canBuy(path):
		return
	changeCost(path, 3)
	
	PlayerStats.maxHp += 1
	hpBar.addPip()

func _on_atk_up_button_down() -> void:
	var path = "UpgradeList/AtkUp/Label"
	if not canBuy(path):
		return
	changeCost(path, 4)
	
	PlayerStats.atk += 1
	atkBar.addPip()

func _on_spd_up_button_down() -> void:
	var path = "UpgradeList/SpdUp/Label"
	if not canBuy(path):
		return
	changeCost(path, 5)
	
	PlayerStats.spd += 0.5
	spdBar.addPip()

func _on_attack_button_down() -> void:
	var path = "UpgradeList/Attack/Label"
	if not canBuy(path):
		return
	changeCost(path, 10)
	
	if not PlayerStats.attack:
		PlayerStats.attack = true
		attack.text = "Attack Cooldown"
	else:
		PlayerStats.atkSpd -= 0.5
		
	if PlayerStats.atkSpd <= 1:
		attack.visible=false
		
	atkAbility.visible = true
	atkAbility.text = "Cd: " + str(PlayerStats.atkSpd) + " sec"

func _on_shoot_button_down() -> void:
	var path = "UpgradeList/Shoot/Label"
	if not canBuy(path):
		return
	changeCost(path, 10)
	
	if not PlayerStats.shoot:
		PlayerStats.shoot = true
		shoot.text = "Shoot Cooldown"
	else:
		PlayerStats.shtSpd -= 0.5
		
	if PlayerStats.shtSpd <= 1:
		shoot.visible=false
		
	shotAbility.visible = true
	shotAbility.text = "Cd: " + str(PlayerStats.shtSpd) + " sec"

func _on_dash_button_down() -> void:
	var path = "UpgradeList/Dash/Label"
	if not canBuy(path):
		return
	changeCost(path, 20)
	
	if not PlayerStats.dash:
		PlayerStats.dash = true
		dash.text = "Dash Cooldown"
	else:
		PlayerStats.dashCd -= 1
		
	if PlayerStats.dashCd <= 1:
		dash.visible=false
	
	dashAbility.visible = true
	dashAbility.text = "Cd: " + str(PlayerStats.dashCd) + " sec"

func _on_mult_button_down() -> void:
	var path = "UpgradeList/Mult/Label"
	if not canBuy(path):
		return
	var cost = get_node(path)
	cost.text = str((int)(cost.text) *2)
	
	PlayerStats.mult += 1
	multBar.addPip()

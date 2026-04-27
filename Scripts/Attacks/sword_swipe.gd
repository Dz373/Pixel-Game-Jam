extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.takeHit(PlayerStats.atk)

func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	queue_free()

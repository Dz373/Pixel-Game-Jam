extends Area2D

@export var damage: int

func _on_body_entered(body: Node2D) -> void:
	body.updateHp(-damage)
	$Explosion.play("default")
	$Sprite2D.visible = false


func _on_explosion_animation_finished() -> void:
	queue_free()

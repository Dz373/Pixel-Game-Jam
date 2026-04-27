extends CharacterBody2D

var damage: int

func shoot(dir: Vector2, speed: float, atk: int):
	velocity = dir * speed
	damage = atk

func _process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().is_class("TileMapLayer"):
			queue_free()
			return
		
		if collision.get_collider().collision_layer == 1:
			collision.get_collider().updateHp(-damage)
		elif collision.get_collider().collision_layer == 64:
			collision.get_collider().takeHit(damage)
		
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

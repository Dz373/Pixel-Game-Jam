extends Node2D

@export var area: int
@export var time: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D/CollisionShape2D.shape.radius = area
	
	await get_tree().create_timer(time).timeout
	
	$Area2D.monitoring = true
	$Explosion.play("default")

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.updateHp(-1)


func _on_explosion_animation_finished() -> void:
	queue_free()

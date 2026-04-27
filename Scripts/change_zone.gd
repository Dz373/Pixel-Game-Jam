extends Area2D

@export var nextZone: PackedScene

func _on_body_entered(_body: Node2D) -> void:
	get_tree().call_deferred("change_scene_to_packed", nextZone)


extends Area2D

@onready var sprite_window = $Window

var tween: Tween


func fade_window(alpha: float) -> void:
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(
		sprite_window,
		"modulate:a",
		alpha,
		0.3
	)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		fade_window(0.5)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		fade_window(1.0)

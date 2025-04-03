extends Area2D


@onready var pickup_animation: Callable = $PickupAnimation.play.bind(&"pickup")


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.has_method("add_score_point"):
		body.add_score_point()
		pickup_animation.call_deferred()

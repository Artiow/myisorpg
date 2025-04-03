extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.has_method("kill"):
		print_debug(self, " is killing ", body)
		body.kill()

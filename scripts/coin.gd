extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print_debug("collision with: ", body)
	queue_free()

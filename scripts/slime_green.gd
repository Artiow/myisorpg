extends Node2D


const SPEED = 50


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast: RayCast2D = $RayCast2D


var direction = 1


func _process(delta: float) -> void:
	if raycast.is_colliding():
		direction *= -1
		sprite.set_deferred("flip_h", !sprite.flip_h)
		raycast.set_deferred("target_position", -1 * raycast.target_position)
	position.x += direction * SPEED * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.has_method("kill"):
		body.kill()

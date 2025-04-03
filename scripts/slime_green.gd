extends CharacterBody2D


@onready var sprite: AnimatedSprite2D = $AnimatedSprite
@onready var wall_raycast: RayCast2D = $WallRayCast

@export var max_distance: float = 500.0
@export var speed: float = 50.0

var start_position: Vector2
var direction: int = 1
var dead: bool = false


func _ready() -> void:
	start_position = position
	velocity.x = direction * speed


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.x = move_toward(velocity.x, 0, delta) 
	else:
		velocity.x = direction * speed

	move_and_slide()

	if is_on_floor() and (wall_raycast.is_colliding()):# or _is_far_from_start()):
		_flip()


func _is_far_from_start() -> bool:
	return abs(global_position.x - start_position.x) > max_distance


func _flip() -> void:
	direction *= -1
	wall_raycast.target_position = -1 * wall_raycast.target_position
	sprite.flip_h = not sprite.flip_h


func _on_hit_range_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.has_method("kill"):
		print_debug(self, " is killing ", body)
		body.kill()


func kill() -> void:
	if not dead:
		print_debug("Killed ", self)
		queue_free()

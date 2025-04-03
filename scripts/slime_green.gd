extends CharacterBody2D

enum MaxDistanceType {RELATIVE, GLOBAL}

@onready var sprite: AnimatedSprite2D = $AnimatedSprite
@onready var wall_raycast: RayCast2D = $WallRayCast

@export var max_distance_type := MaxDistanceType.RELATIVE
@export var max_distance := 1000.0
@export var speed := 50.0

var _position_supplier: Callable
var _start_position: Vector2
var _direction := 1
var _dead := false


func _ready():
	if max_distance_type:
		_position_supplier = get_global_position
	else:
		_position_supplier = get_position

	_start_position = _position_supplier.call()
	velocity.x = _direction * speed


func _physics_process(delta: float):
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
		velocity.x = move_toward(velocity.x, 0, delta)
	else:
		velocity.x = _direction * speed

	move_and_slide()

	if is_on_floor() and (wall_raycast.is_colliding() or is_far_from_start()):
		flip()


func is_far_from_start() -> bool:
	return abs(_position_supplier.call().x - _start_position.x) > max_distance


func flip():
	_direction *= -1
	wall_raycast.target_position.x *= -1
	sprite.flip_h = not sprite.flip_h


func _on_hit_range_body_entered(body: Node2D):
	if body is Player2D:
		body.kill(self)


func kill(killer: Node2D = null):
	if not _dead:
		queue_free()
		if killer:
			print_debug(self, " is killed by ", killer)
		else:
			print_debug(self, " is killed")

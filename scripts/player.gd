extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -275.0
const JUMP_LIMIT = 2


@onready var raycast = $RayCast2D
@onready var sprite = $AnimatedSprite2D

  
var jump_count = 0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		# Add the gravity.
		velocity += get_gravity() * delta
	elif Input.is_action_just_pressed("ui_down") and raycast.is_colliding():
		# Handle drop through platforms.
		drop_process()

	# Handle jump.
	jump_process()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0 and sprite.flip_h:
			sprite.set_deferred("flip_h", false)
		if direction < 0 and not sprite.flip_h:
			sprite.set_deferred("flip_h", true)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func drop_process() -> void:
	var collider = raycast.get_collider()
	if collider is CollisionObject2D and collider.has_method("drop"):
		collider.drop()


func jump_process() -> void:
	if Input.is_action_just_pressed("ui_accept") and can_jump():
		velocity.y = JUMP_VELOCITY
		jump_count += 1
	elif is_on_floor():
		jump_count = 0


func can_jump() -> bool:
	return is_on_floor() or (jump_count < JUMP_LIMIT)

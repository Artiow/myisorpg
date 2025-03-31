extends CharacterBody2D


const SPEED: float = 150.0
const JUMP_VELOCITY: float = -275.0
const JUMP_LIMIT: int = 2


@onready var game_manager: Node = %GameManager


@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var raycast: RayCast2D = $RayCast2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var kill_timer: Timer = $KillTimer
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound


var jump_count: int = 0
var dead: float = false


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		# Add the gravity.
		velocity += get_gravity() * delta
	elif Input.is_action_just_pressed("drop_down") and raycast.is_colliding():
		# Handle drop through platforms.
		drop_process()

	# Handle jump.
	jump_process()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction and not dead:
		velocity.x = direction * SPEED
		if direction > 0 and sprite.flip_h:
			sprite.set_deferred("flip_h", false)
		if direction < 0 and not sprite.flip_h:
			sprite.set_deferred("flip_h", true)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if not dead:
		if is_on_floor():
			if direction:
				sprite.call_deferred("play", "run")
			else:
				sprite.call_deferred("play", "idle")
		elif sprite.animation != "jump":
			sprite.call_deferred("play", "jump")

	move_and_slide()


func drop_process() -> void:
	var collider = raycast.get_collider()
	if collider is CollisionObject2D and collider.has_method("drop"):
		collider.drop()


func jump_process() -> void:
	if Input.is_action_just_pressed("jump") and can_jump():
		call_deferred("_do_jump")
		jump_count += 1
	elif is_on_floor():
		jump_count = 0


func _do_jump() -> void:
	sprite.play("jump")
	jump_sound.play()
	velocity.y = JUMP_VELOCITY


func can_jump() -> bool:
	return not dead and (is_on_floor() or (jump_count < JUMP_LIMIT))


func kill() -> void:
	if not dead:
		dead = true
		Engine.time_scale = 0.5
		call_deferred("_do_kill")
		kill_timer.start()


func _do_kill() -> void:
	sprite.play("death", 2)
	death_sound.play()
	velocity.y = JUMP_VELOCITY / 2
	collision.queue_free()


func _on_kill_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()


func add_score_point() -> void:
	game_manager.add_player_score_point()
	

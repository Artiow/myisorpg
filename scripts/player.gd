class_name Player2D
extends CharacterBody2D

@onready var game_manager: GameManager = %GameManager
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var platform_raycast: RayCast2D = $PlatformRayCast
@onready var sprite: AnimatedSprite2D = $AnimatedSprite
@onready var kill_timer: Timer = $KillTimer
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

@export var speed := 150.0
@export var jump_velocity := -275.0
@export var jump_limit := 2
@export var death_jump_velocity := -150.0

var _jump_count := 0
var _is_dead := false


func _physics_process(delta: float):
	_apply_gravity(delta)
	_handle_platform_drop()
	_handle_jump()
	_handle_movement()
	move_and_slide()


func _apply_gravity(delta: float):
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
		_play_fall_animation()


func _handle_platform_drop():
	if Input.is_action_just_pressed(&"drop_down") and platform_raycast.is_colliding():
		var platform := platform_raycast.get_collider()
		if platform is Platform2D:
			platform.drop_through()


func _handle_jump():
	if Input.is_action_just_pressed(&"jump") and can_jump():
		velocity.y = jump_velocity
		_jump_count += 1
		_play_jump_animation()
	elif is_on_floor():
		_jump_count = 0


func _handle_movement():
	var direction := Input.get_axis(&"move_left", &"move_right")

	if not _is_dead and direction:
		velocity.x = direction * speed
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if not _is_dead and is_on_floor():
		sprite.play(&"run" if direction else &"idle")


func can_jump() -> bool:
	return not _is_dead and (is_on_floor() or _jump_count < jump_limit)


func collect(item: StringName, quantity: int = 1):
	if item == &"coin":
		game_manager.add_player_score(quantity)


func kill(killer: Node2D = null) -> void:
	if _is_dead:
		return

	_is_dead = true
	Engine.time_scale = 0.5
	_handle_death()
	kill_timer.start()

	if killer:
		print_debug(self, " is killed by ", killer)
	else:
		print_debug(self, " is killed")


func _handle_death():
	velocity.y = death_jump_velocity
	collision_shape.queue_free()
	_play_death_animation()


func _play_fall_animation():
	if not _is_dead and sprite.animation != &"jump":
		sprite.play(&"jump")


func _play_jump_animation():
	if sprite.animation == &"jump":
		sprite.frame = 0

	sprite.play(&"jump")
	jump_sound.play()


func _play_death_animation():
	sprite.play(&"death", 2)
	death_sound.play()


func _on_kill_timer_timeout():
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()

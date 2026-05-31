extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound

@export var WALK_VELOCITY: float = 150.0
@export var JUMP_VELOCITY: float = -400.0
@export var MAX_RUN_VELOCITY: float = 300.0
@export var RUN_ACCELERATION: float = 300.0
@export var RUN_DEACCELERATION: float = 400.0
@export var SPAWN_ANIMATION_DURATION_SECONDS: int = 0

var current_speed_limit: float

var can_control: bool = false


func _ready() -> void:
	spawn_player()
	current_speed_limit = WALK_VELOCITY
	
func spawn_player():
	can_control = false
	animated_sprite_2d.play("spawn")
	print("animation started")
	await get_tree().create_timer(SPAWN_ANIMATION_DURATION_SECONDS).timeout
	animated_sprite_2d.stop()
	animated_sprite_2d.play("idle")
	can_control = true
	print("animation finished")


func _physics_process(delta: float) -> void:
	if not can_control:
		return
	apply_gravity(delta)
	handle_jump()
	update_run_state(delta)
	handle_horizontal_movement()
	update_animation()

	move_and_slide()


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and can_jump():
		do_jump()


func update_run_state(delta: float) -> void:
	if should_accelerate_run():
		current_speed_limit = min(
			current_speed_limit + RUN_ACCELERATION * delta,
			MAX_RUN_VELOCITY
		)
	else:
		current_speed_limit = max(
			current_speed_limit - RUN_DEACCELERATION * delta,
			WALK_VELOCITY
		)


func should_accelerate_run() -> bool:
	return (
		is_on_floor()
		and Input.is_action_pressed("run")
		and abs(Input.get_axis("left", "right")) > 0.0
	)


func handle_horizontal_movement() -> void:
	var direction := Input.get_axis("left", "right")

	if direction != 0:
		velocity.x = direction * current_speed_limit
		update_facing_direction(direction)
	else:
		velocity.x = move_toward(
			velocity.x,
			0,
			current_speed_limit
		)


func update_facing_direction(direction: float) -> void:
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true


func update_animation() -> void:
	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite_2d.animation = "jump"
		else:
			animated_sprite_2d.animation = "fall"
		return

	if abs(velocity.x) > 1:
		animated_sprite_2d.animation = "run"
	else:
		animated_sprite_2d.animation = "idle"


func can_jump() -> bool:
	return is_on_floor()


func do_jump() -> void:
	velocity.y = JUMP_VELOCITY
	animated_sprite_2d.animation = "jump"
	jump_sound.play()

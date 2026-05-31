extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var spawn_sound: AudioStreamPlayer2D = $SpawnSound
@onready var player_movement: Node = $PlayerMovement



@export var WALK_VELOCITY: float = 150.0
@export var JUMP_VELOCITY: float = -400.0
@export var MAX_RUN_VELOCITY: float = 300.0
@export var RUN_ACCELERATION: float = 300.0
@export var RUN_DEACCELERATION: float = 400.0
@export var SPAWN_ANIMATION_DURATION_SECONDS: int = 0

var current_speed_limit: float

var can_control: bool = false


func _ready() -> void:
	player_movement.init(self)
	spawn_player()
	#current_speed_limit = WALK_VELOCITY
	
func spawn_player():
	player_movement.set_can_move(false)
	can_control = false
	animated_sprite_2d.play("spawn")
	spawn_sound.play()
	print("animation started")
	await get_tree().create_timer(SPAWN_ANIMATION_DURATION_SECONDS) .timeout
	animated_sprite_2d.stop()
	animated_sprite_2d.play("idle")
	player_movement.set_can_move(true)
	can_control = true
	print("animation finished")


func _physics_process(delta: float) -> void:
	if not can_control:
		return
	handle_jump()
	update_run_state()
	handle_horizontal_movement()
	update_animation()

	move_and_slide()


func handle_jump() -> void:
	if Input.is_action_just_pressed("jump"):
		player_movement.start_jumping()
		return
	if Input.is_action_just_released("jump"):
		player_movement.stop_jumping()


func update_run_state() -> void:
	if should_accelerate_run():
		player_movement.start_running()
		
	else:
		player_movement.stop_running()


func should_accelerate_run() -> bool:
	return (
		is_on_floor()
		and Input.is_action_pressed("run")
		and abs(Input.get_axis("left", "right")) > 0.0
	)


func handle_horizontal_movement() -> void:
	var direction := Input.get_axis("left", "right")
	player_movement.handle_horizontal_movement(direction)

	#if direction != 0:
		#velocity.x = direction * current_speed_limit
		#update_facing_direction(direction)
	#else:
		#velocity.x = move_toward(
			#velocity.x,
			#0,
			#current_speed_limit
		#)


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


func do_jump() -> void:
	#velocity.y = JUMP_VELOCITY
	animated_sprite_2d.animation = "jump"
	jump_sound.play()

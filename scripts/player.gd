extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound


@export var WALK_VELOCITY: int
@export var JUMP_VELOCITY: int
@export var RUN_VELOCITY: int


func _physics_process(delta: float) -> void:
	
	# Add running animation
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "run"
	else:
		animated_sprite_2d.animation = "idle"
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if velocity.y > 0:
			animated_sprite_2d.animation = "fall"

	# Handle jump.
	if Input.is_action_just_pressed("jump") and can_jump():
		do_jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	var new_speed = calculate_new_speed()
	if direction:
		velocity.x = direction * new_speed
	else:
		velocity.x = move_toward(velocity.x, 0, new_speed)

	move_and_slide()
	global_position = global_position.round()
	
	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true
		
func can_jump() -> bool:
	return is_on_floor()
	
func is_running() -> bool:
	return Input.is_action_pressed("run")
	
func can_run() -> bool:
	return is_on_floor()
	
func calculate_new_speed() -> int:
	if can_run() and is_running():
		return RUN_VELOCITY
	return WALK_VELOCITY
	
func do_jump():
	velocity.y = JUMP_VELOCITY
	animated_sprite_2d.animation = "jump"
	jump_sound.play()

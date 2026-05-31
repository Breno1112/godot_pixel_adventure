extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var spawn_sound: AudioStreamPlayer2D = $SpawnSound
@onready var movement: PlayerMovement = $PlayerMovement

@export var spawn_duration: float = 0.8

var can_control: bool = false


func _ready() -> void:
	movement.init(self)
	await spawn_player()


func _physics_process(delta: float) -> void:
	if not can_control:
		return

	handle_input()
	movement.tick(delta)

	update_animation()
	update_facing_direction()

	move_and_slide()


# ----------------------------
# INPUT
# ----------------------------

func handle_input() -> void:
	var direction := Input.get_axis("left", "right")
	movement.set_direction(direction)

	if Input.is_action_just_pressed("jump"):
		movement.start_jumping()
		jump_sound.play()

	if Input.is_action_just_released("jump"):
		movement.stop_jumping()

	if should_run():
		movement.start_running()
	else:
		movement.stop_running()


func should_run() -> bool:
	return (
		is_on_floor()
		and Input.is_action_pressed("run")
		and abs(Input.get_axis("left", "right")) > 0.0
	)


# ----------------------------
# SPAWN
# ----------------------------

func spawn_player() -> void:
	can_control = false
	movement.set_can_move(false)

	animated_sprite_2d.play("spawn")
	spawn_sound.play()

	await get_tree().create_timer(spawn_duration).timeout

	animated_sprite_2d.play("idle")

	movement.set_can_move(true)
	can_control = true


# ----------------------------
# ANIMATION
# ----------------------------

func update_animation() -> void:
	if not can_control:
		return

	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite_2d.animation = "jump"
		else:
			animated_sprite_2d.animation = "fall"
		return

	if abs(velocity.x) > 1.0:
		animated_sprite_2d.animation = "run"
	else:
		animated_sprite_2d.animation = "idle"


func update_facing_direction() -> void:
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = true

extends CharacterBody2D

@onready var movement: PlayerMovement = $PlayerMovement
@onready var animation: PlayerAnimation = $PlayerAnimation
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var spawn_sound: AudioStreamPlayer2D = $SpawnSound

@export var spawn_duration: float = 0.8

var can_control: bool = false


func _ready() -> void:
	movement.init(self)
	animation.init(self)
	await spawn_player()


func _physics_process(delta: float) -> void:
	if not can_control:
		return

	handle_input()

	movement.tick(delta)
	move_and_slide()

	animation.tick()
	animation.update_facing_direction()


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

	animation.sprite.play("spawn")
	spawn_sound.play()

	await get_tree().create_timer(spawn_duration).timeout

	animation.sprite.play("idle")

	movement.set_can_move(true)
	can_control = true

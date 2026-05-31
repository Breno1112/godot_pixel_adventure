extends CharacterBody2D

@onready var animation: PlayerAnimation = $PlayerAnimation
@onready var state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var spawn_sound: AudioStreamPlayer2D = $SpawnSound

@export var spawn_duration: float = 0.8

var can_control: bool = false


func _ready() -> void:
	state_machine.init(self)
	await spawn_player()
	state_machine.change_state(IdleState.new())


func _physics_process(delta: float) -> void:
	if not can_control:
		return

	state_machine.physics_update(delta)
	move_and_slide()

	animation.tick()
	animation.update_facing_direction()


# ----------------------------
# SPAWN
# ----------------------------

func spawn_player() -> void:
	can_control = false
	jump_sound.stop()
	spawn_sound.play()

	await get_tree().create_timer(spawn_duration).timeout

	can_control = true

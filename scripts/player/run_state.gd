extends PlayerState
class_name RunState



var speed := 150.0
@export var max_speed := 300.0
@export var min_speed := 150.0
var accel := 300.0
var decel := 400.0


func enter() -> void:
	animation.play("run")


func handle_input() -> void:
	var dir := Input.get_axis("left", "right")

	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.change_state(PlayerStateMachine.PlayerStateEnum.JUMP)
		return

	if dir == 0:
		state_machine.change_state(PlayerStateMachine.PlayerStateEnum.IDLE)


func physics_update(delta: float) -> void:
	var dir := Input.get_axis("left", "right")

	# run acceleration
	if Input.is_action_pressed("run"):
		speed = min(speed + accel * delta, max_speed)
	else:
		speed = max(speed - decel * delta, min_speed)

	player.velocity.x = dir * speed
	player.velocity.y += player.get_gravity().y * delta

	if not player.is_on_floor():
		state_machine.change_state(PlayerStateMachine.PlayerStateEnum.FALL)

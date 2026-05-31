extends PlayerState
class_name FallState


func enter():
	animation.play("fall")

func handle_input() -> void:
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.change_state(PlayerStateMachine.PlayerStateEnum.JUMP)


func physics_update(delta: float) -> void:
	player.velocity.y += player.get_gravity().y * delta

	var dir := Input.get_axis("left", "right")
	player.velocity.x = dir * 200.0

	if player.is_on_floor():
		if dir == 0:
			state_machine.change_state(PlayerStateMachine.PlayerStateEnum.IDLE)
		else:
			state_machine.change_state(PlayerStateMachine.PlayerStateEnum.RUN)

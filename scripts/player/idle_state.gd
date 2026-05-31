extends PlayerState
class_name IdleState


func enter() -> void:
	animation.play("idle")
	player.velocity.x = move_toward(player.velocity.x, 0, 9999)


func handle_input() -> void:
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.change_state(PlayerStateMachine.PlayerStateEnum.JUMP)
		return

	if Input.get_axis("left", "right") != 0:
		state_machine.change_state(PlayerStateMachine.PlayerStateEnum.RUN)


func physics_update(delta: float) -> void:
	player.velocity.y += player.get_gravity().y * delta

	if not player.is_on_floor():
		state_machine.change_state(PlayerStateMachine.PlayerStateEnum.FALL)

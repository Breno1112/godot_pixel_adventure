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
		if Input.is_action_pressed("run"):
			state_machine.change_state(PlayerStateMachine.PlayerStateEnum.RUN)
		else:
			state_machine.change_state(PlayerStateMachine.PlayerStateEnum.WALK)


func physics_update(delta: float) -> void:
	player.velocity.y += player.get_gravity().y * delta
	
	decay_player_speed(delta, 0)

	if not player.is_on_floor():
		state_machine.change_state(PlayerStateMachine.PlayerStateEnum.FALL)


func decay_player_speed(delta: float, dir: int) -> void:
	player.speed = max(player.speed - player.decel * delta, player.min_speed_const)

	player.velocity.x = dir * player.speed

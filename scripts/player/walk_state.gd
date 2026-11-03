extends PlayerState
class_name WalkState

func enter() -> void:
	animation.play("walk")
	player.velocity.x = move_toward(player.velocity.x, 0, 10)


func handle_input():
		
		
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.change_state(PlayerStateMachine.PlayerStateEnum.JUMP)
		return
	
	var dir := Input.get_axis("left", "right")

	if dir == 0:
		state_machine.change_state(PlayerStateMachine.PlayerStateEnum.IDLE)
	else:
		if Input.is_action_pressed("run"):
			state_machine.change_state(PlayerStateMachine.PlayerStateEnum.RUN)
			return


func physics_update(delta: float) -> void:
	var dir := Input.get_axis("left", "right")
	
	player.speed = max(player.speed - player.decel * delta, player.min_speed_const)

	player.velocity.x = dir * player.speed
	player.velocity.y += player.get_gravity().y * delta

	if not player.is_on_floor():
		state_machine.change_state(PlayerStateMachine.PlayerStateEnum.FALL)

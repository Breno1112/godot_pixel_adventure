extends PlayerState
class_name RunState


func enter() -> void:
	animation.play("run")


func handle_input() -> void:
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		state_machine.change_state(PlayerStateMachine.PlayerStateEnum.JUMP)
		return
		
	var dir := Input.get_axis("left", "right")

	if dir == 0:
		state_machine.change_state(PlayerStateMachine.PlayerStateEnum.IDLE)
	
	if Input.is_action_just_released("run"):
		state_machine.change_state(PlayerStateMachine.PlayerStateEnum.WALK)
		return


func physics_update(delta: float) -> void:
	var dir := Input.get_axis("left", "right")

	# run acceleration
	player.speed = min(player.speed + player.accel * delta, player.max_speed)

	player.velocity.x = dir * player.speed
	player.velocity.y += player.get_gravity().y * delta

	if not player.is_on_floor():
		state_machine.change_state(PlayerStateMachine.PlayerStateEnum.FALL)

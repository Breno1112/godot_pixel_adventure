extends PlayerState
class_name JumpState

var jump_velocity := -850.0
var jump_pressed := true


func enter() -> void:
	player.velocity.y = jump_velocity
	animation.play("jump")


func handle_input() -> void:
	if Input.is_action_just_released("jump"):
		jump_pressed = false
		player.velocity.y *= 0.5  # variable jump height


func physics_update(delta: float) -> void:
	player.velocity.y += player.get_gravity().y * delta

	var dir := Input.get_axis("left", "right")
	player.velocity.x = dir * 200.0

	if player.velocity.y > 0:
		state_machine.change_state(PlayerStateMachine.PlayerStateEnum.FALL)

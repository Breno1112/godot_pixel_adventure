extends Node

class_name PlayerStateMachine

enum PlayerStateEnum {IDLE, WALK, RUN, JUMP, FALL}

var allowed_stated = {
	PlayerStateEnum.IDLE: IdleState.new(),
	PlayerStateEnum.WALK: WalkState.new(),
	PlayerStateEnum.RUN: RunState.new(),
	PlayerStateEnum.JUMP: JumpState.new(),
	PlayerStateEnum.FALL: FallState.new()
}

var player: CharacterBody2D
var animation: PlayerAnimation
var current_state: PlayerState


func init(p: CharacterBody2D, anim: PlayerAnimation) -> void:
	player = p
	animation = anim


func change_state(new_state_enum: PlayerStateEnum) -> void:
	var new_state = allowed_stated.get(new_state_enum)
	if new_state == null:
		return
	if current_state:
		current_state.exit()
	current_state = new_state
	current_state.player = player
	current_state.state_machine = self
	current_state.animation = animation

	current_state.enter()


func physics_update(delta: float) -> void:
	if current_state:
		current_state.handle_input()
		current_state.physics_update(delta)

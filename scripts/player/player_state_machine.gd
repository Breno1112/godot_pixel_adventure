extends Node

class_name PlayerStateMachine

enum PlayerStateEnum {IDLE, WALK, RUN, JUMP, FALL}

@onready var idle_state: IdleState = $IdleState
@onready var run_state: RunState = $RunState
@onready var jump_state: JumpState = $JumpState
@onready var fall_state: FallState = $FallState
@onready var walk_state: WalkState = $WalkState

var allowed_states := {}

var player: CharacterBody2D
var animation: PlayerAnimation
var current_state: PlayerState

func _ready():
	allowed_states = {
		PlayerStateEnum.IDLE: idle_state,
		PlayerStateEnum.WALK: walk_state,
		PlayerStateEnum.RUN: run_state,
		PlayerStateEnum.JUMP: jump_state,
		PlayerStateEnum.FALL: fall_state
	}


func init(p: CharacterBody2D, anim: PlayerAnimation) -> void:
	player = p
	animation = anim


func change_state(new_state_enum: PlayerStateEnum) -> void:
	var new_state = allowed_states.get(new_state_enum)
	print("new state is ", new_state)
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

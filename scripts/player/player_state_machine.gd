extends Node
class_name PlayerStateMachine

var player: CharacterBody2D
var animation: PlayerAnimation
var current_state: PlayerState


func init(p: CharacterBody2D, anim: PlayerAnimation) -> void:
	player = p
	animation = anim


func change_state(new_state: PlayerState) -> void:
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

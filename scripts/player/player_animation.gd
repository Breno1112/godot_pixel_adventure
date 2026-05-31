extends Node
class_name PlayerAnimation

@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var player: CharacterBody2D = $".."

func tick() -> void:
	pass  # animation is now driven by state machine externally


func play_state(state_name: String) -> void:
	print("playing state", state_name)
	sprite.animation = state_name


func update_facing_direction() -> void:
	if player.velocity.x > 0:
		sprite.flip_h = false
	elif player.velocity.x < 0:
		sprite.flip_h = true

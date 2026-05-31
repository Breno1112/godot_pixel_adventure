extends Node
class_name PlayerAnimation

@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"

var player: CharacterBody2D


func init(p: CharacterBody2D) -> void:
	player = p


func tick() -> void:
	if player == null:
		return

	if not player.is_on_floor():
		update_air_animation()
		return

	update_ground_animation()


func update_air_animation() -> void:
	if player.velocity.y < 0:
		sprite.animation = "jump"
	else:
		sprite.animation = "fall"


func update_ground_animation() -> void:
	if abs(player.velocity.x) > 1.0:
		sprite.animation = "run"
	else:
		sprite.animation = "idle"


func update_facing_direction() -> void:
	if player.velocity.x > 0:
		sprite.flip_h = false
	elif player.velocity.x < 0:
		sprite.flip_h = true

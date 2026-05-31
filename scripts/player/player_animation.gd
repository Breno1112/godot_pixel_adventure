extends Node
class_name PlayerAnimation

@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var player: CharacterBody2D = $".."



func init(p: CharacterBody2D) -> void:
	player = p


func play(animation_name: String) -> void:
	if sprite.animation != animation_name:
		sprite.play(animation_name)


func update_facing_direction() -> void:
	if player.velocity.x > 0:
		sprite.flip_h = false
	elif player.velocity.x < 0:
		sprite.flip_h = true

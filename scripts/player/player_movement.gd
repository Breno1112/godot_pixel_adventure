extends Node
class_name PlayerMovement

var player: CharacterBody2D

# ----------------------------
# CONFIG
# ----------------------------

@export var walk_velocity: float = 150.0
@export var max_run_velocity: float = 300.0
@export var run_acceleration: float = 300.0
@export var run_deceleration: float = 400.0
@export var jump_velocity: float = -850.0

# ----------------------------
# STATE
# ----------------------------

var current_speed_limit: float
var is_running: bool = false
var jump_request: bool = false
var can_move: bool = false
var direction: float = 0.0


# ----------------------------
# INIT
# ----------------------------

func init(p: CharacterBody2D) -> void:
	player = p
	current_speed_limit = walk_velocity


func set_can_move(value: bool) -> void:
	can_move = value


# ----------------------------
# MAIN LOOP
# ----------------------------

func tick(delta: float) -> void:
	if not can_move:
		return

	apply_gravity(delta)
	update_run_state(delta)
	apply_horizontal_movement()
	apply_jump()


# ----------------------------
# INPUT FROM PLAYER
# ----------------------------

func set_direction(value: float) -> void:
	direction = value


func start_running() -> void:
	is_running = true


func stop_running() -> void:
	is_running = false


func start_jumping() -> void:
	jump_request = true


func stop_jumping() -> void:
	jump_request = false


# ----------------------------
# PHYSICS
# ----------------------------

func apply_gravity(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta


func update_run_state(delta: float) -> void:
	if is_running:
		current_speed_limit = min(
			current_speed_limit + run_acceleration * delta,
			max_run_velocity
		)
	else:
		current_speed_limit = max(
			current_speed_limit - run_deceleration * delta,
			walk_velocity
		)


func apply_horizontal_movement() -> void:
	if direction != 0:
		player.velocity.x = direction * current_speed_limit
	else:
		player.velocity.x = move_toward(
			player.velocity.x,
			0,
			current_speed_limit
		)


func apply_jump() -> void:
	if not jump_request:
		return

	if not player.is_on_floor():
		return

	player.velocity.y = jump_velocity
	jump_request = false

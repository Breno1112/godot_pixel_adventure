extends Node

var player: CharacterBody2D

@export var WALK_VELOCITY: float = 150.0
@export var JUMP_VELOCITY: float = -850.0
@export var MAX_RUN_VELOCITY: float = 300.0
@export var RUN_ACCELERATION: float = 300.0
@export var RUN_DEACCELERATION: float = 400.0
@export var SPAWN_ANIMATION_DURATION_SECONDS: int = 0

var current_speed_limit: float
var is_player_running: bool = false
var is_player_jumping: bool = false
var can_move: bool = false


func init(p: CharacterBody2D):
	player = p
	current_speed_limit = WALK_VELOCITY


func _physics_process(delta: float) -> void:
	if not can_move:
		return
	apply_gravity(delta)
	handle_jump()
	update_run_state(delta)
	#move_and_slide()
	
func set_can_move(new_value: bool):
	can_move = new_value
	
func start_running():
	is_player_running = true
	
func stop_running():
	is_player_running = false


func apply_gravity(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
		
func update_run_state(delta: float) -> void:
	if is_player_running:
		current_speed_limit = min(
			current_speed_limit + RUN_ACCELERATION * delta,
			MAX_RUN_VELOCITY
		)
	else:
		current_speed_limit = max(
			current_speed_limit - RUN_DEACCELERATION * delta,
			WALK_VELOCITY
		)
		
func handle_horizontal_movement(direction: float) -> void:

	if direction != 0:
		player.velocity.x = direction * current_speed_limit
	else:
		player.velocity.x = move_toward(
			player.velocity.x,
			0,
			current_speed_limit
		)
		
func handle_jump() -> void:
	if is_player_jumping and can_jump():
		do_jump()
		
func can_jump() -> bool:
	return player.is_on_floor()


func do_jump() -> void:
	player.velocity.y = JUMP_VELOCITY
	
func start_jumping():
	is_player_jumping = true

func stop_jumping():
	is_player_jumping = false

extends CharacterBody2D

@export var speed = 600.0
@export var jump_strength = 1500.0
@export var maximum_jumps = 2
@export var double_jump_strength = 1200.0
@export var gravity = 200

@onready var _pivot: Node2D = get_node("Starherder")
@onready var _animation_player: AnimationPlayer = get_node("Starherder/AnimationPlayer")

var _jumps_made := 0
var _velocity := Vector2.ZERO

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	var _horizontal_direction = (
		Input.get_action_strength("ui_right")
		- Input.get_action_strength("ui_left")
	)
	
	_velocity.x = _horizontal_direction * speed 
	_velocity.y += gravity  *  delta 
	
	var is_falling = _velocity.y > 0.0 and not is_on_floor()
	var is_jumping = Input.is_action_just_pressed("ui_accept") and is_on_floor()
	var is_double_jumping = Input.is_action_just_pressed("ui_accept") and is_falling
	var is_jump_cancelled = Input.is_action_just_released("ui_accept") and _velocity.y < 0.0
	var is_running = is_on_floor() and not is_zero_approx(_velocity.x)
	var is_idling = is_on_floor() and is_zero_approx(_velocity.x) and is_zero_approx(_velocity.y)
	
	if is_jumping:
		_jumps_made += 1
		_velocity.y = -jump_strength
	elif is_double_jumping:
		_jumps_made += 1
		if _jumps_made <= maximum_jumps:
			_velocity.y = -double_jump_strength
	elif is_jump_cancelled:
		_velocity.y = 0.0
	elif is_idling or is_running:
		_jumps_made = 0
		
	move_and_slide()

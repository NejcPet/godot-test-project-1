extends CharacterBody2D


const SPEED = 2000.0
const JUMP_VELOCITY = -2000.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("Starherder/AnimationPlayer")

func _ready():
	get_node("Starherder/AnimationPlayer").play("IDLE")
func _physics_process(delta):

	if not is_on_floor():
		velocity.y += gravity * delta


	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("RISE")

	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction == -1:
		get_node("Starherder").scale.x = abs(self.scale.x) * -1
	elif direction == 1:
		get_node("Starherder").scale.x *= abs(self.scale.x)
		
	if direction:
		velocity.x = direction * SPEED
		anim.play("WALK")
	else:	
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play("IDLE")
	
	if velocity.y > 0:
		
		anim.play("FALL")
	move_and_slide()

func _attack():
	if Input.is_action_pressed("attack"):
		anim.play("ATTACK")

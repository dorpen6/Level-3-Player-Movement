# PLAYER MOVEMENT LEVEL 1

extends CharacterBody3D

const SPEED = 5.0
const JUMP = 5.0

var gravity = 9.8

func _physics_process(delta):
	# GRAVITY
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	# JUMP
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP
	
	# GET INPUT DIRECTIONS
	var input_directions = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_directions.x, 0, input_directions.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0
	
	
	move_and_slide()

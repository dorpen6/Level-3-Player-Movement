extends CharacterBody3D

var speed
@export var walk_speed = 5.0
@export var run_speed = 10.0
@export var jump = 5.0
@export var gravity = 9.8

func _physics_process(delta):
	# GRAVITY
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# JUMP
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump
		
	# SPRINT
	if Input.is_action_pressed("Run"):
		speed = run_speed
	else:
		speed = walk_speed
		
	# GET INPUT DIRECTIONS 2D
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	
	# APPLY IT TO 3D
	var directions = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if directions:
		velocity.x = directions.x * speed
		velocity.z = directions.z * speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		
	move_and_slide()

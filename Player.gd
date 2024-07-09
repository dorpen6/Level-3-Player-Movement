extends CharacterBody3D

var speed
@export var walk_speed = 5.0
@export var run_speed = 10.0
@export var jump = 5.0
@export var gravity = 9.8
@export var sensitivity = 0.003
@export var bob_freq = 2.0
@export var bob_amp = 0.1
@export var t_bob = 0.0
@onready var head = $Head
@onready var camera = $Head/Camera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

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
	var directions = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if directions:
		velocity.x = directions.x * speed
		velocity.z = directions.z * speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		
	# HEAD BOB
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_freq) * bob_amp
	pos.x = cos(time * bob_freq / 2) * bob_amp
	return pos

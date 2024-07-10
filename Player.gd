extends CharacterBody3D

var speed
@export var walk_speed = 5.0
@export var run_speed = 10.0
@export var jump = 5.0
@export var gravity = 9.8
@export var sensitivity = 0.003
@onready var head = $Head
@onready var camera = $Head/Camera
@export var bob_freq = 2.0
@export var bob_amp = 0.1
@export var t_bob = 0.0
@export var base_fov = 75.0
@export var fov_change = 1.5

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta):
	# HANDLE GRAVITY
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	# HANDLE JUMP
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump
		
	# HANDLE SPRINT
	if Input.is_action_pressed("Run"):
		speed = run_speed
	else:
		speed = walk_speed
		
	# GET INPUT DIRECTIONS 2D
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	
	# TRANSFORM IT TO 3D
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 6.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 6.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.x * speed, delta * 2.0)
	
	# HEAD BOB
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, run_speed * 2)
	var target_fov = base_fov + fov_change * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
		
	move_and_slide()
	
func headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_freq) * bob_amp
	pos.x = cos(time * bob_freq / 2) * bob_amp
	return pos

extends CharacterBody3D

@export var SPEED = 5.0
@export var JUMP = 5.0
@export var SENSITIVITY = 0.003

@onready var head = $Head
@onready var camera = $Head/Camera

var gravity = 9.8

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x,deg_to_rad(-40), deg_to_rad(60))
		
func _physics_process(delta):
	# GRAVITY
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# JUMP
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP
		
	# GET INPUT DIRECTIONS 2D
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	
	# TURN IT TO 3D
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0

		
	move_and_slide()

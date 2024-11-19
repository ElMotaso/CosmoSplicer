extends CharacterBody2D

const MOVEMENT_SPEED = 10
const ROTATION_SPEED = 2.0
const FRICTION_FACTOR = 0.99
# const TAN30DEG = tan(deg_to_rad(30))

var MAX_SPEED = 500

func _physics_process(_delta):
	if Input.is_action_pressed("ui_left"):
		rotation -= ROTATION_SPEED * _delta
	if Input.is_action_pressed("ui_right"):
		rotation += ROTATION_SPEED * _delta
	
	up_direction = Vector2(cos(rotation), sin(rotation))
	var direction = 0
	if Input.is_action_pressed("ui_up"):
		direction += 1
	if Input.is_action_pressed("ui_down"):
		direction -= 1

	# Calculate new velocity based on up_direction and movement speed
	velocity += up_direction.normalized() *  direction * MOVEMENT_SPEED
	var velocity2 = velocity.normalized() * MAX_SPEED
	
	if velocity.abs() > velocity2.abs():
		velocity = velocity2
	
	velocity *= FRICTION_FACTOR
	
	move_and_slide()

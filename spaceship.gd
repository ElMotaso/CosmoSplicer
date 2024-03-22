extends CharacterBody2D

@export var bullet: PackedScene

const MOVEMENT_SPEED = 10
const ROTATION_SPEED = 2.0
const FRICTION_FACTOR = 0.99
# const TAN30DEG = tan(deg_to_rad(30))

var MAX_SPEED = 4000
var CAN_SHOOT = true
var LIFE = 100

func _ready():
	add_to_group("spaceship")

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


func shoot():
	if CAN_SHOOT:
		CAN_SHOOT = false
		var b = bullet.instantiate()
		owner.add_child(b)
		b.transform = $Marker2D.global_transform
		get_node("ShootTimer").start()



func _process(_delta):
	if Input.is_action_pressed("shoot"):
		shoot()
		


func _on_spaceship_shoot_timer_timeout():
	CAN_SHOOT = true


func reduce_life(damage):
	LIFE -= damage

func die():
	queue_free()

func _on_area_2d_area_entered(area):
	if area.is_in_group("bullet"):
		var damage = area.get("damage")
		reduce_life(damage)
	elif area.is_in_group("spaceship"):
		reduce_life(10)
	if LIFE <= 0:
		die()

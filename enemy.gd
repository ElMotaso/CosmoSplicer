extends CharacterBody2D

@export var bullet: PackedScene

const MOVEMENT_SPEED = 10
const ROTATION_SPEED = 2
const FRICTION_FACTOR = 0.99


var MAX_SPEED = 20000
var CAN_SHOOT = true
var IS_BUMPER = true
var MOVING = false
var LIFE = 100
var sees_player = true

func _ready():
	add_to_group("spaceship")


func has_line_of_sight_to(player):
	var start_position = self.global_position
	var end_position = player.global_position  # Make sure this references your player node correctly

	# Create a PhysicsRayQueryParameters2D object
	var ray_query = PhysicsRayQueryParameters2D.new()
	ray_query.from = start_position
	ray_query.to = end_position
	# You can set additional parameters on ray_query as needed, like collision mask

	# Perform the raycast using Physics2DServer
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(ray_query)
	space_state.intersect_ray(ray_query)

	# Check if the raycast hit something
	if result.size() > 0:
		# Check if the collider of the raycast result is the player
		if result.collider == player:
			return true
		else:
			return false
	else:
		# No collision detected, implying no direct line of sight (e.g., open space)
		return false



func angle_to(player):
	if player == null:
		return -PI
	var player_position = player.global_position
	var enemy_position = global_position
	var direction_to_player = player_position - enemy_position
	var angle_to_player = atan2(direction_to_player.y, direction_to_player.x)
	var angle_difference = angle_to_player - rotation
	while angle_difference < -PI:
		angle_difference += 2 * PI
	while angle_difference > PI:
		angle_difference -= 2 * PI
	return angle_difference

func _physics_process(_delta):
	var player = get_node_or_null("/root/World/Spaceship")
	
	if sees_player:
		var angle_to_player = angle_to(player)
		if angle_to_player < 0:
			rotation -= ROTATION_SPEED * _delta
		else:
			rotation += ROTATION_SPEED * _delta
		
		
		up_direction = Vector2(cos(rotation), sin(rotation))
		var direction = 0
		if -PI/3 < angle_to_player and angle_to_player < PI/3:
			direction += 1
			MOVING = true
		else:
			MOVING = false
		
		if -PI/20 < angle_to_player and angle_to_player < PI/20:
			shoot()
		

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



func _on_enemy_shoot_timer_timeout():
	CAN_SHOOT = true
	
func reduce_life(damage):
	LIFE -= damage

func die():
	call_deferred("queue_free")

func _on_area_2d_area_entered(area):
	if area.is_in_group("bullet"):
		var damage = area.get("damage")
		reduce_life(damage)
	elif area.is_in_group("spaceship"):
		reduce_life(10)
	if LIFE <= 0:
		die()


func _on_check_player_timer_timeout():
	if has_line_of_sight_to(get_node_or_null("/root/World/Spaceship")):
		sees_player = true
	else:
		sees_player = true

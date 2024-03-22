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
var current_waypoint = null

func _ready():
	add_to_group("spaceship")
	$RayCast2D.enabled = true
	$RayCast2D.collide_with_areas = true
	$RayCast2D.collide_with_bodies = true


func sees(player):
	if player == null:
		return false
	$RayCast2D.target_position = $RayCast2D.to_local(player.global_position)
	$RayCast2D.force_raycast_update()
	if $RayCast2D.is_colliding():
		if $RayCast2D.get_collider() == player:
			return true
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


func get_closest_waypoint():
	var waypoints = get_node_or_null("/root/World/Map/Waypoints")
	if waypoints == null:
		return null
	
	var closest_waypoint = null
	var min_dist = INF
	
	for waypoint in waypoints.get_children():
		var dist = global_position.distance_to(waypoint.global_position)
		if dist < min_dist:
			min_dist = dist
			closest_waypoint = waypoint
	return closest_waypoint

func new_waypoint():
	var name = current_waypoint.name
	var index_str = name.replace("Waypoint", "")
	var index = int(index_str)
	var neighbours = get_node_or_null("/root/World/Map").waypoint_connections[index - 1]
	var waypoint_index = neighbours[randi_range(0, neighbours.size() - 1)] - 1
	return get_node_or_null("/root/World/Map/Waypoints").get_children()[waypoint_index]

func _physics_process(_delta):
	var player = get_node_or_null("/root/World/Spaceship")
	
	if sees(player) and false:
		sees_player = true
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
	elif current_waypoint != null and !sees_player:
		if global_position.distance_to(current_waypoint.global_position) < 300:
			current_waypoint = new_waypoint()
		var angle_to_waypoint = angle_to(current_waypoint)
		if angle_to_waypoint < 0:
			rotation -= ROTATION_SPEED * _delta
		else:
			rotation += ROTATION_SPEED * _delta
		
		
		up_direction = Vector2(cos(rotation), sin(rotation))
		var direction = 0
		if -PI/3 < angle_to_waypoint and angle_to_waypoint < PI/3:
			direction += 1
			MOVING = true
		else:
			MOVING = false
		

		# Calculate new velocity based on up_direction and movement speed
		velocity += up_direction.normalized() *  direction * MOVEMENT_SPEED
		var velocity2 = velocity.normalized() * MAX_SPEED
		
		if velocity.abs() > velocity2.abs():
			velocity = velocity2
		
		velocity *= FRICTION_FACTOR
	else:
		sees_player = false
		current_waypoint = get_closest_waypoint()
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
	if sees(get_node_or_null("/root/World/Spaceship")):
		sees_player = sees_player
	else:
		sees_player = sees_player

func _on_checkwaypont_timer_timeout():
	pass

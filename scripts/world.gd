extends Node2D

var player
var player_health_bar

var enemy
var enemy_health_bar

const ship_offset = Vector2(-100, 150)

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node_or_null("Spaceship")
	player_health_bar = get_node("PlayerHealthBar")
	
	enemy = get_node_or_null("Enemy")
	enemy_health_bar = get_node("EnemyHealthBar")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		var player_position = player.global_position
		player_health_bar.global_position = player_position + ship_offset
	elif player_health_bar != null:
		player_health_bar.queue_free()
		
	
	if enemy != null:
		var enemy_position = enemy.global_position
		enemy_health_bar.global_position =  enemy_position + ship_offset
	elif enemy_health_bar != null:
		enemy_health_bar.queue_free()

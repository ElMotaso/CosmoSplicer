extends Area2D

var speed = 4000
var damage = 5

var collision_enabled_after_seconds = 0.1

func _ready():
	add_to_group("bullet")
	# Disable collision shape at the start
	$CollisionShape2D.disabled = false
	
	
func _physics_process(delta):
	position += transform.x * speed * delta
	

func _on_bullet_timer_timeout():
	queue_free()


func _on_area_entered(area):
	queue_free()


func _on_life_timer_timeout():
	$CollisionShape2D.disabled = false


func _on_body_entered(body):
	queue_free()

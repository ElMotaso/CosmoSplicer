extends Sprite2D

var char_tex = load("res://ressources/spaceship_new.png") 

func _ready():
	set_process_input(true)
	texture = char_tex

func _input(event):
	if get_node("/root/World/Enemy").MOVING:
		texture = load("res://ressources/spaceship_new_fire.png")
	else:
		texture = char_tex

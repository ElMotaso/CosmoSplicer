extends Sprite2D

var char_tex = load("res://ressources/spaceship_new.png") 

func _ready():
	set_process_input(true)
	texture = char_tex

func _input(event):
	if Input.is_action_pressed("ui_up"):
		texture = load("res://ressources/spaceship_new_fire.png")
	else:
		texture = char_tex

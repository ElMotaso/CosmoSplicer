extends Control

var function = ""
var pulsating = false
var hasButton = true

func getFontInfo(shadow=false):
	var alignment = "[center]"
	var font = "[font='res://ressources/menu/namco-font/NamcoRegular-lgzd.ttf']"
	var shadowEffect = "[color=black][font_size=31]"
	var textEffect = "[color=green][font_size=32]"
	if shadow:
		return alignment + font + shadowEffect
	else:
		return alignment + font + textEffect
		
func getText(shadow=false, pulsed=false):
	if pulsed and hasButton:
		return "[pulse]" + getFontInfo(shadow) + function
	else:
		return getFontInfo(shadow) + function

func createButtonTexts(pulsed):
	get_node("RichTextLabel").text = getText(false, pulsed)
	get_node("RichTextLabelShadow").text = getText(true, pulsed)
	if !hasButton:
		get_node("Button").visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if self.name.contains("Start"):
		function = "start game"
	elif self.name.contains("Options"):
		function = "options"
	elif self.name.contains("Quit"):
		function = "quit"
	elif self.name.contains("PlayerCount"):
		hasButton = false
		function = "number of players"
	elif self.name.contains("Menu"):
		function = "menu"
	else:
		function = "unknown"
	createButtonTexts(false)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	if function == "start game":
		get_tree().change_scene_to_file("res://scenes/world.tscn")
	elif function == "options":
		get_tree().change_scene_to_file("res://scenes/menus/options.tscn")
	elif function == "menu":
		get_tree().change_scene_to_file("res://scenes/menus/menu.tscn")
	elif function == "quit":
		get_tree().quit()


func _on_mouse_entered():
	pulsating = true
	get_node("PulseTimer").start()
	createButtonTexts(true)

func _on_mouse_exited():
	pulsating = false


func _on_pulse_timer_timeout():
	if !pulsating:
		createButtonTexts(false)
		get_node("PulseTimer").stop()

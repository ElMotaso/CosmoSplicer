extends Node2D


var waypoint_connections = [
	[2], # 1
	[1, 3], # 2
	[2, 4, 5], # 3
	[3, 5, 15, 16, 23], # 4
	[4, 6], # 5
	[5, 7], # 6
	[6, 8], # 7
	[7, 9], # 8
	[8, 10, 11, 12], # 9
	[9, 11, 12, 13, 14, 15, 20, 22], # 10
	[9, 10, 12, 13, 14, 15, 20], # 11
	[9, 10, 11], # 12
	[10, 11, 14, 15, 20, 22], # 13
	[10, 11, 13, 15, 20, 21, 22], # 14
	[4, 10, 11, 13, 14, 16, 20, 21, 22, 23], # 15
	[4, 15, 17, 20, 21, 22, 23], # 16
	[16, 18, 20], # 17
	[17, 19], # 18
	[18], # 19
	[10, 11, 13, 14, 15, 16, 17, 21, 22], # 20
	[14, 15, 16, 20, 22], # 21
	[10, 13, 14, 15, 16, 20, 21], # 22
	[4, 15, 16], # 23
]

# keypoints: 4, 15, 10, 11
# base points: 1, 12, 19
# routing points: 2, 3, 5, 6, 7, 8, 9, 13, 14, 17, 18, 23
# choices points: 16, 20, 21, 22


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("map")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

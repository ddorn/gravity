extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const B_LVL1_grav = 100
const B_LVL2_grav = 150
const B_LVL3_grav = 200
const B_LVL4_grav = 300
const B_LVL5_grav = 400

onready var animGrav = $HBoxContainer/AnimGrav
onready var animTreeGrav = $HBoxContainer/AnimTreeGrav

# Called when the node enters the scene tree for the first time.
func _ready():
	animTreeGrav.active=true
	animTreeGrav['parameters/playback'].start("LVL3_grav")
	_gravity_con_change(B_LVL1_grav)

func _gravity_con_change(new_gravity):
	animTreeGrav['parameters/playback'].start("LVL3_grav")
	if new_gravity <= B_LVL1_grav :
		animTreeGrav['parameters/playback'].travel("LVL1_grav")
	elif new_gravity <= B_LVL2_grav :
		animTreeGrav['parameters/playback'].travel("LVL2_grav")
	elif new_gravity <= B_LVL3_grav :
		animTreeGrav['parameters/playback'].travel("LVL3_grav")
	elif new_gravity <= B_LVL4_grav :
		animTreeGrav['parameters/playback'].travel("LVL4_grav")
	elif new_gravity <= B_LVL5_grav :
		animTreeGrav['parameters/playback'].travel("LVL5_grav")
	print("new_gravity :", new_gravity);



func _on_Player_new_grav(gravityMode):
	_gravity_con_change(gravityMode)


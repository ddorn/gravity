extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const B_LOW_GRAV = 100
const B_MID_GRAV = 200
const B_HIGH_GRAV = 400

onready var animGrav = $HBoxContainer/AnimGrav
onready var animTreeGrav = $HBoxContainer/AnimTreeGrav

# Called when the node enters the scene tree for the first time.
func _ready():
	animTreeGrav.active=true
	animTreeGrav['parameters/playback'].start("Mid_grav")
	_gravity_con_change(B_MID_GRAV)

func _gravity_con_change(new_gravity):
	if new_gravity <= B_LOW_GRAV :
		animTreeGrav['parameters/playback'].travel("Low_grav")
	if new_gravity <= B_MID_GRAV :
		animTreeGrav['parameters/playback'].travel("Mid_grav")
	if new_gravity <= B_HIGH_GRAV :
		animTreeGrav['parameters/playback'].travel("High_grav")

func _on_Player_new_grav(gravityMode):
	_gravity_con_change(gravityMode)

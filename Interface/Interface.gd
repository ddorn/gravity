extends Control

const B_LVL1_grav = 100
const B_LVL2_grav = 150
const B_LVL3_grav = 200
const B_LVL4_grav = 300
const B_LVL5_grav = 400

const Utils = preload("res://utils.gd")

const MIN_GRAVITY = 50
const MAX_GRAVITY = 300
const GRAVITY_CHANGE = 50  # units per key press

onready var animGrav = $HBoxContainer/AnimGrav
onready var animTreeGrav = $HBoxContainer/AnimTreeGrav

# Called when the node enters the scene tree for the first time.
func _ready():
	animTreeGrav.active=true
	animTreeGrav['parameters/playback'].start("LVL3_grav")

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


func _input(event):
	var gravity = Utils.get_gravity(self)
	
	if Input.is_action_just_pressed("ui_q"):
		gravity += GRAVITY_CHANGE
	
	if Input.is_action_just_pressed("ui_e"):
		gravity -= GRAVITY_CHANGE
	
	gravity = clamp(gravity, MIN_GRAVITY, MAX_GRAVITY)
	Utils.set_gravity(self, gravity)

	_gravity_con_change(gravity)

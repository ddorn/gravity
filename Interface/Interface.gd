extends Control

const Utils = preload("res://utils.gd")

const MIN_GRAVITY = 100
const MAX_GRAVITY = 400
const grav_thresholds = [100, 150, 200, 250, 300, 350, 400]

const GRAVITY_CHANGE = 50  # units per key press



func _gravity_con_change(new_gravity):
	var index = grav_thresholds.bsearch(new_gravity)
	$SpriteGrav.frame = len(grav_thresholds) - index - 1


func _input(event):
	var gravity = Utils.get_gravity(self)
	
	if Input.is_action_just_pressed("ui_q"):
		gravity += GRAVITY_CHANGE
	
	if Input.is_action_just_pressed("ui_e"):
		gravity -= GRAVITY_CHANGE
	
	gravity = clamp(gravity, MIN_GRAVITY, MAX_GRAVITY)
	
	if gravity != Utils.get_gravity(self):
		Utils.set_gravity(self, gravity)
		_gravity_con_change(gravity)
		var avg_grav = (MAX_GRAVITY + MIN_GRAVITY) / 2
		var grav_prop = 2 * (gravity - avg_grav) / (MAX_GRAVITY - MIN_GRAVITY)  # in the range [-1, 1]
		$GravChangedSound.pitch_scale = 1 - grav_prop * 0.8
		$GravChangedSound.play()

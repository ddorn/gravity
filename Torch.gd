extends Sprite

const Utils = preload("res://utils.gd")

func _ready():
	$Animation.play("default")
	$Animation.seek(randf() * $Animation.current_animation_length)

func _process(_delta):
	var gravity = Utils.get_gravity(self)
	
	var prev_state = $Animation.current_animation

	if gravity >= 200:
		$Animation.current_animation = "default"
	else:
		$Animation.current_animation = "low_grav"

	if prev_state != $Animation.current_animation:
		# Randomize start on change
		$Animation.seek(randf() * $Animation.current_animation_length)

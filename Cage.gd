extends StaticBody2D


var buttons_pressed = 0
export(int, 0, 10) var buttons_needed_to_open
export(float) var open_speed = 0.1
var open = false


func react_to_button_press(pressed):
	if pressed:
		buttons_pressed += 1
	else:
		buttons_pressed -= 1
	
	if buttons_pressed >= buttons_needed_to_open:
		open = true
		$Collision.set_deferred("disabled", true)

	var frame_goal
	if open:
		frame_goal = 7
	else:
		frame_goal = int(lerp(0.0, 4.0, buttons_pressed / float(buttons_needed_to_open)))
		
	var duration = abs($Sprite.frame - frame_goal) * open_speed
	
	$Tween.interpolate_property($Sprite, "frame", $Sprite.frame, frame_goal, duration)
	$Tween.start()

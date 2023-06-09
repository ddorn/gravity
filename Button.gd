extends Area2D

var pressed = 0

signal pressed
signal unpressed
signal change_state(pressed)

func _on_Button_body_entered(_body):
	if pressed == 0:
		$Click.play()
		emit_signal("pressed")
		emit_signal("change_state", true)

	pressed += 1

func _on_Button_body_exited(_body):
	pressed -= 1
	
	if pressed == 0:
		$Unclick.play()
		emit_signal("unpressed")
		emit_signal("change_state", false)

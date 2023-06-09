extends Label


export(float, 0, 20) var lifetime = 3.0
export(bool) var one_shot = true
var did_shot = false

func _ready():
	hide()
	
func trigger():
	if one_shot and did_shot:
		return
		
	did_shot = true
	if $Timer.time_left == 0:
		$Anim.play("spawn")
	else:
		$Timer.start(lifetime)

func _on_Anim_animation_finished(anim_name):
	if anim_name == "spawn":
		$Timer.start(lifetime)

func _on_Timer_timeout():
	$Anim.play("death")

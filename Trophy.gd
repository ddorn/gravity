extends StaticBody2D


export(PackedScene) var next_level

var sound_length 

func _ready():
	sound_length = $SuccessSound.stream.get_length()
	print(sound_length)

# Time since the player entered the area
var entered = false

func _process(delta):
	if not entered:
		return
	
	$Path2D/PathFollow2D.unit_offset += delta / sound_length

func _on_Area2D_body_entered(body):
	if entered:
		return
	
	entered = true
	
	if body.get("TYPE") == "player":
		$SuccessSound.play()

func _on_SuccessSound_finished():
	get_tree().change_scene_to(next_level)

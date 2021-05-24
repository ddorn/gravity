extends Node2D

const Utils = preload("res://utils.gd")

func _ready():
	if !(PlayerVariables.scene == 2):
		PlayerVariables.mort = 0;
		PlayerVariables.scene = 2;


func _process(delta):
	if $SpikeHint.overlaps_body($Player):
		if Utils.get_gravity(self) < 200:
			$SpikeHint/Hint.trigger()

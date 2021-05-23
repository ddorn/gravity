extends Node2D


func _ready():
	if !(PlayerVariables.scene == 2):
		PlayerVariables.mort = 0;
		PlayerVariables.scene = 2;

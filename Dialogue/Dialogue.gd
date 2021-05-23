extends Control



func _ready():
	hide();
	if PlayerVariables.scene == 2 && PlayerVariables.mort == 1 :
		show();


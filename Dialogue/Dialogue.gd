extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var BoiteDialogue = $Dialogue/Inner
onready var TexteBoiteDialogue = $Dialogue/Inner/Outer/RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	hide();
	if PlayerVariables.scene == 1 && PlayerVariables.mort == 1 :
		show();
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dialogue = [" ", "Utilisez Q et E pour modifier l'intensité de la gravité.", "Bonne Chance"]
var page = 0;
var texte_visible;
# Called when the node enters the scene tree for the first time.
func _ready():
	set_visible_characters(0);
	if PlayerVariables.scene == 1 && PlayerVariables.mort == 1 :
		_set_Dialogue_Page(1, 1)

func _set_Dialogue_Page(page, est_visible):
	print("_set_Dialogue_Page :", page, " , ", est_visible);
	texte_visible = est_visible;
	set_bbcode(dialogue[page]);

func _on_Timer_timeout():
	if texte_visible == 1 :
		set_visible_characters(get_visible_characters()+1);

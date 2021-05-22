extends RichTextLabel


var dialogue = [" ", "Utilisez Q et E pour modifier l'intensite de la gravite.", "Bonne Chance"]
var page = 0
var texte_visible


func _ready():
	set_visible_characters(0);
	if PlayerVariables.scene == 2 && PlayerVariables.mort == 1 :
		_set_Dialogue_Page(1, 1)


func _set_Dialogue_Page(in_page, est_visible):
	print("_set_Dialogue_Page :", in_page, " , ", est_visible);
	texte_visible = est_visible;
	set_bbcode(dialogue[in_page]);


func _on_Timer_timeout():
	if texte_visible == 1 :
		set_visible_characters(get_visible_characters()+1);

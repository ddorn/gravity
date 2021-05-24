extends Node2D

var box_taken = false

func _process(delta):
	$BoxHint.position = $Box.position
	if $BoxHint.overlaps_body($Player) and not $Player.box_on_shoulder and not box_taken:
		$BoxHint/Hint.trigger()

	if $Player.box_on_shoulder:
		box_taken = true

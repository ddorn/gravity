extends KinematicBody2D

const Utils = preload("res://utils.gd")

func collide_with(collision: KinematicCollision2D, body):
	if body.has_method("kill"):
		# 200 is the default gravity. So by default RHS is 1. 
		var normalized_repulsion = 200.0 / Utils.get_gravity(self)
		# By default, if the player is faster than 20 px/s they die.
		var normalized_velocity = (body.last_velocity.y / 2 + 15) / 20.0
		
		if normalized_velocity > normalized_repulsion:
			body.kill()
			
			$Sprite.frame = 3
		else:
			$Sprite.frame = 1

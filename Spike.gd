extends KinematicBody2D

const Utils = preload("res://utils.gd")

signal mort()

func collide_with(collision: KinematicCollision2D, body):
	if body.get("TYPE") == "player":
		
		# We can't use velocity because it can be reset by the collision before activating the Area2D
		# print("velocity on spike hit:", body.last_velocity.y)
		# print("gravity:", Utils.get_gravity(self))
		
		# 200 is the default gravity. So by default RHS is 1. 
		var normalized_repulsion = 200.0 / Utils.get_gravity(self)
		var normalized_velocity = body.last_velocity.y / 20.0
		# print(normalized_velocity, " >? ", normalized_repulsion)
		# By default, if the player is faster than 20 px/s they die.
		if normalized_velocity > normalized_repulsion:
			PlayerVariables.mort += 1;
			get_tree().reload_current_scene()

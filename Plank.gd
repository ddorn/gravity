extends StaticBody2D

const Utils = preload("res://utils.gd")
export(float) var force_to_break = 1000

var force_on_plank = 0
# Some objects collide twice in one frame, so we keep track of that.
var objects_collisioned_with = []

func collide_with(collision: KinematicCollision2D, body):
	if body.position.y < position.y and not body in objects_collisioned_with:
		objects_collisioned_with.append(body)
		
		force_on_plank += min(100, body.last_velocity.y) * 4
		force_on_plank += Utils.get_gravity(self)

func _physics_process(delta):
	if force_on_plank > force_to_break:
		# queue_free()
		call_deferred("free")
		
	force_on_plank = 0
	objects_collisioned_with = []

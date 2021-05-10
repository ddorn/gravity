extends KinematicBody2D

export(float, 0, 100) var move_speed = 50
export(Array, NodePath) var patrol_path
export(bool) var loop = true
export(NodePath) var avoid_body 
export(float, 10.0, 100.0) var avoid_radius = 15.0

var paused = true

# Here we follow multiple paths one after the other, 
# so path_index correspond to which path we are following
# and point_index is the position in the path.
var path_index = 0
var point_index = 0
var patrol_points = []

var velocity = Vector2.ZERO

func _ready():
	for path in patrol_path:
		patrol_points.append(
			get_node(path).curve.get_baked_points()
		)

func _physics_process(delta):
	if !patrol_path:
		return
		
	# Loop paths if needed
	if path_index >= len(patrol_path):
		if loop:
			path_index = 0
		else:
			# If we don't loop, there is nothing to do.
			return

	# update the pause attribute
	if paused:
		if avoid_body:
			var body_pos = get_node(avoid_body).position
			if position.distance_to(body_pos) < avoid_radius:
				paused = false
		else:
			paused = false
	
	# Still paused ? Don't do anything.	
	if paused:
		return
	
	
	var target = patrol_points[path_index][point_index]
	
	if position.distance_to(target) < 1:
		point_index += 1
		if point_index >= len(patrol_points[path_index]):
			point_index = 0
			path_index += 1  
			paused = !!avoid_body
			return  
		target = patrol_points[path_index][point_index]

	velocity = (target - position).normalized() * move_speed * delta
	self.position += velocity

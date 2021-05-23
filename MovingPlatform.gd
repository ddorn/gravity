extends KinematicBody2D

export(float, 0, 100) var move_speed = 50
export(Array, NodePath) var patrol_path
export(bool) var loop = true
export(Array, NodePath) var avoid_areas

export(NodePath) var avoid_body 

var paused = true

# Here we follow multiple paths one after the other, 
# so path_index correspond to which path we are following
# and point_index is the position in the path.
var path_index = 0
var point_index = 0
var patrol_points = []
var offsets = []

var velocity = Vector2.ZERO

func _ready():
	for path in patrol_path:
		patrol_points.append(
			get_node(path).curve.get_baked_points()
		)
		offsets.append(get_node(path).global_position)

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
			if get_node(avoid_areas[path_index]).overlaps_body(get_node(avoid_body)):
				paused = false
		else:
			paused = false
	
	# Still paused ? Don't do anything.
	if paused:
		return
	
	var target = patrol_points[path_index][point_index] + offsets[path_index]
	
	if position.distance_to(target) < 1:
		point_index += 1
		if point_index >= len(patrol_points[path_index]):
			point_index = 0
			path_index += 1  
			paused = !!avoid_body
			return  
		target = patrol_points[path_index][point_index] + offsets[path_index]

	velocity = (target - position).normalized() * move_speed * delta
	self.position += velocity

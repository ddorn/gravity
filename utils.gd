# Functions to be used from other parts of the code.
# They should all be static func

static func get_gravity(node):
	# Get the global gravity for a node. A node has to be passed to get the right scene
	return Physics2DServer.area_get_param(node.get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY)

static func set_gravity(node, value):
	# Set the global gravity for the scene of the node.
	Physics2DServer.area_set_param(node.get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY, value)

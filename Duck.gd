extends KinematicBody2D

const Utils = preload("res://utils.gd")

export(float, -200.0, 200.0) var horizontal_speed = 100
var velocity = Vector2.RIGHT * horizontal_speed
var spawn
var timer = 0
var last_velocity
const horizontal_acceleration = 0.05
var dead_for = 0
export(int, 0, 10) var respawn_delay = 2

func _ready():
	spawn = Vector2(position)
	$Sprite/Animation.play("default")
	respawn()

func _physics_process(delta):
	timer += delta
	dead_for -= delta
	if dead_for > 0:
		return
	
	var vertical_force = (Utils.get_gravity(self) - 200) / 4
	vertical_force += sin(timer * 10) * 10
	velocity.y += vertical_force * delta
	
	velocity.x = lerp(velocity.x, horizontal_speed, horizontal_acceleration)
	
	last_velocity = Vector2(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if position.x < -20 and velocity.x < 0:
		respawn()
	elif position.x > 360 + 20 and velocity.x > 0:
		respawn()
		
	
	# Handle the collisions with other objects
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.collider.has_method("collide_with"):
			collision.collider.collide_with(collision, self)

	
func respawn():
	position = Vector2(spawn)
	velocity = Vector2.RIGHT * horizontal_speed
	dead_for = respawn_delay

func kill():
	respawn()
	$Kill.play()

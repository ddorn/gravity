extends KinematicBody2D

const Utils = preload("res://utils.gd")

export(float, -200.0, 200.0) var horizontal_speed = 100
var velocity = Vector2.RIGHT * horizontal_speed
var spawn
var timer = 0
const horizontal_acceleration = 0.05

func _ready():
	spawn = Vector2(position)
	$Sprite/Animation.play("default")
	respawn()

func _physics_process(delta):
	timer += delta
	
	var vertical_force = (Utils.get_gravity(self) - 200) / 4
	vertical_force += sin(timer * 10) * 10
	velocity.y += vertical_force * delta
	
	velocity.x = lerp(velocity.x, horizontal_speed, horizontal_acceleration)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if position.x < 0 and velocity.x < 0:
		respawn()
	elif position.x > 360 and velocity.x > 0:
		respawn()
	
func respawn():
	position = Vector2(spawn)
	velocity = Vector2.RIGHT * horizontal_speed

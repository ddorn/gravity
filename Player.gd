extends KinematicBody2D

const Utils = preload("utils.gd")

const TYPE = "player"

signal new_grav(gravityMode)

const ACCELERATION = 512
const JUMP_IMPULSE = 100
const GRAVITY_CHANGE = 200  # units per seconds

const AIR_FRICTION = 0.03
const GROUND_FRICTION = 0.4
const MAX_SPEED = 64

var last_velocity = Vector2.ZERO
var velocity = Vector2.ZERO
var circle_shape

onready var sprite = $Sprite
onready var animationplayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2(200,0))
	Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY, 200)


func _physics_process(delta):
	gravity_control(delta)
	# Player inputs
	last_velocity = Vector2(velocity)
	
	var GRAVITY = 200;
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	if x_input != 0:
		velocity.x += x_input * ACCELERATION * delta
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
		sprite.flip_h = (x_input < 0)

	var friction
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -JUMP_IMPULSE
		friction = GROUND_FRICTION

		if abs(velocity.x) > 1:
			animationplayer.play("run")
		else:
			animationplayer.play("idle")

	else:
		animationplayer.play("jump")
		friction = AIR_FRICTION
		
		if Input.is_action_just_released("ui_up") and velocity.y < 0:
			velocity.y /= 2.0
	
	if x_input == 0:
		velocity.x = lerp(velocity.x, 0, friction)
	
	GRAVITY = Utils.get_gravity(self)
	velocity.y += GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)


# This would have to be put in the gravitometre node/script
func gravity_control(delta):
	var gravity = Utils.get_gravity(self)
	gravity += GRAVITY_CHANGE * (Input.get_action_strength("ui_q") - Input.get_action_strength("ui_e")) * delta
	gravity = clamp(gravity, 50, 400)
	Utils.set_gravity(self, gravity)
	emit_signal("new_grav", gravity)

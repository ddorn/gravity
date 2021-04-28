extends KinematicBody2D


const ACCELERATION = 512
const JUMP_IMPULSE = 100

const AIR_FRICTION = 0.03
const GROUND_FRICTION = 0.4
const MAX_SPEED = 64

var velocity = Vector2.ZERO
var circle_shape

onready var sprite = $Sprite
onready var animationplayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2(200,0))
	Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY, 200)
	pass # Replace with function body.

func _physics_process(delta):
	# Player inputs
	
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
	
	GRAVITY = Physics2DServer.area_get_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY)
	velocity.y += GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
	_grav_con()

func _grav_con():
	if Input.is_action_just_pressed("ui_q"):
		Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY, 400)
	if Input.is_action_just_pressed("ui_w"):
		Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY, 200)
	if Input.is_action_just_pressed("ui_e"):
		Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY, 100)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

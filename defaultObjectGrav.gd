extends KinematicBody2D

const ACCELERATION = 512
const JUMP_IMPULSE = 200

const AIR_FRICTION = 0.03
const GROUND_FRICTION = 0.4
const MAX_SPEED = 64

var velocity = Vector2.ZERO
var circle_shape

onready var sprite = $Sprite
# onready var animationplayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	# Player inputs
	
	var GRAVITY = 200;
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if Input.is_action_just_pressed("ui_s"):
			velocity.y = -JUMP_IMPULSE			
	
	var friction
	if is_on_floor():
		friction = GROUND_FRICTION
	else:
		friction = AIR_FRICTION
		
	velocity.x = lerp(velocity.x, 0, friction)
	
	GRAVITY = Physics2DServer.area_get_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY)
	velocity.y += GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)

extends KinematicBody2D

const Utils = preload("utils.gd")


const ACCELERATION = 512
const JUMP_IMPULSE = 100
const GRAVITY_CHANGE = 200  # units per seconds

const AIR_FRICTION = 0.03
const GROUND_FRICTION = 0.4
const MIN_SPEED = 30
const MAX_SPEED = 64

var last_velocity = Vector2.ZERO
var velocity = Vector2.ZERO
var circle_shape
var not_pushing;
var GRAVITY = 200;

# Called when the node enters the scene tree for the first time.
func _ready():
	last_velocity = Vector2(velocity)
	velocity.y = 0;
	not_pushing = true

func _physics_process(delta):
	var friction;
	last_velocity = velocity
	if !is_on_floor():
		GRAVITY = Utils.get_gravity(self)
		if not_pushing :
			velocity.x = (last_velocity.x/3);
			if velocity.x < 10 && velocity.x > -10 :
				velocity.x = 0;
		velocity.y += GRAVITY * delta
		friction = AIR_FRICTION
	else : friction = GROUND_FRICTION
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_LeftSide_body_entered(body):
	if body.get("TYPE") == "player":
		GRAVITY = Utils.get_gravity(self)
		if GRAVITY < 300 :
			if GRAVITY < 200 :
				not_pushing = false;
			if MAX_SPEED > body.last_velocity.x && body.last_velocity.x >= MIN_SPEED :
				velocity.x = body.last_velocity.x;
			elif Input.get_action_strength("ui_right") :
				velocity.x = MAX_SPEED;
			velocity.x = velocity.x * (1-(GRAVITY/300));
			move_and_slide(velocity, Vector2.UP)


func _on_RightSide_body_entered(body):
	if body.get("TYPE") == "player":
		GRAVITY = Utils.get_gravity(self)
		if GRAVITY < 300 :
			if GRAVITY < 200 :
				not_pushing = false;
			if -MIN_SPEED > body.last_velocity.x && body.last_velocity.x >= -MAX_SPEED:
				velocity.x = body.last_velocity.x+10;
			elif Input.get_action_strength("ui_left") :
				velocity.x = -MAX_SPEED;
			velocity.x = velocity.x * (1-(GRAVITY/300));
			move_and_slide(velocity, Vector2.UP)

func _on_IsGoingToPush_body_exited(body):
	if body.get("TYPE") == "player":
		not_pushing = true;


func _on_IsGoingToPush_body_entered(body):
	if body.get("TYPE") == "player":
		not_pushing = false;

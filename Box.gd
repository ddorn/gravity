extends KinematicBody2D
class_name Box

const Utils = preload("utils.gd")


const ACCELERATION = 512
const JUMP_IMPULSE = 100
const GRAVITY_CHANGE = 200  # units per seconds

const AIR_FRICTION = 0.03
const GROUND_FRICTION = 0.4
const MIN_SPEED = 16
const MAX_SPEED = 60

var last_velocity = Vector2.ZERO
var velocity = Vector2.ZERO
var picked_up = false;
var not_pushing;
var GRAVITY = 200;
var body_interacted = KinematicBody2D

# Called when the node enters the scene tree for the first time.
func push(movement : Vector2, snap : Vector2, pusher : KinematicBody2D) -> void:
	GRAVITY = Utils.get_gravity(self)
	if GRAVITY > 250 :
		not_pushing = true;
	if !not_pushing :
		if Input.get_action_strength("ui_w") && GRAVITY <= 250  :
			picking_up_box(pusher)
			body_interacted = pusher
		movement.y = 0;
		movement.x = MAX_SPEED*(Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left"))                                
		velocity.x = movement.x
		move_and_slide_with_snap(movement, snap, Vector2.UP, false, 4, PI/4, false)

func _ready():
	last_velocity = Vector2(velocity)
	velocity.y = 0;
	not_pushing = true

func _physics_process(delta):
	var friction;
	GRAVITY = Utils.get_gravity(self)
	if !picked_up :
		var friction_grav_coeff = 1 + GRAVITY/100;
		if !is_on_floor():
			velocity.y += GRAVITY * delta
			friction = AIR_FRICTION
		else : friction = GROUND_FRICTION
		friction = friction*friction_grav_coeff
		if velocity.x > friction*MIN_SPEED :
			velocity.x = velocity.x - friction*MIN_SPEED;
		elif velocity.x > 0 :
			velocity.x = 0; 
		elif velocity.x < -friction*MIN_SPEED :
			velocity.x = velocity.x + friction*MIN_SPEED;
		elif velocity.x < 0 :
			velocity.x = 0; 
		velocity = move_and_slide(velocity, Vector2.UP)
	else : velocity = move_and_slide(velocity, Vector2.UP)

func picking_up_box(pusher : KinematicBody2D):
	picked_up = true;
	pusher.picking_up_box(self)

func putting_down(direction):
	picked_up = false;
	velocity.x = direction*MAX_SPEED
	velocity.y = 0

func box_following_player(movement : Vector2):
	velocity = movement

func _on_LeftSide_body_entered(body):
	if body.get("TYPE") == "player":
		not_pushing = false;


func _on_RightSide_body_entered(body):
	if body.get("TYPE") == "player":
		not_pushing = false;

func _on_LeftSide_body_exited(body):
	if body.get("TYPE") == "player":
		not_pushing = true;


func _on_RightSide_body_exited(body):
	if body.get("TYPE") == "player":
		not_pushing = true;

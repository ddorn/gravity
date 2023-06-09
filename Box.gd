extends KinematicBody2D
class_name Box

const Utils = preload("utils.gd")


const ACCELERATION = 512
const JUMP_IMPULSE = 100
const GRAVITY_CHANGE = 200  # units per seconds

const AIR_FRICTION = 0.03
const GROUND_FRICTION = 0.4
const MIN_SPEED = 16
const MAX_SPEED = 100

var last_velocity = Vector2.ZERO
var velocity = Vector2.ZERO
var picked_up = false;
var not_pushing;
var GRAVITY = 200;
var body_interacted: KinematicBody2D
var spawn_position

func push(movement: Vector2, snap: Vector2, pusher: KinematicBody2D) -> void:
	GRAVITY = Utils.get_gravity(self)
	if GRAVITY > 250:
		not_pushing = true;
	if !not_pushing  :
		movement.y = 0;
		movement.x = MAX_SPEED*(Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left"))                                
		velocity.x = movement.x
		move_and_slide_with_snap(movement, snap, Vector2.UP, false, 4, PI/4, false)

func check_if_picking():
	if Input.is_action_just_pressed("ui_w") && GRAVITY <= 200:
		for body in $PickUpArea.get_overlapping_bodies():
			if body.get("TYPE") == "player":
				picking_up_box(body)
				body_interacted = body

func _ready():
	last_velocity = Vector2(velocity)
	velocity.y = 0;
	not_pushing = true
	spawn_position = Vector2(position)
	$Animation.play("spawn")

func _physics_process(delta):
	var friction;
	GRAVITY = Utils.get_gravity(self)
	check_if_picking()

	if !picked_up:
		var friction_grav_coeff = 1 + GRAVITY/100;
		velocity.y += GRAVITY * delta
		if !is_on_floor():
			friction = AIR_FRICTION
		else:
			friction = GROUND_FRICTION
		friction = friction*friction_grav_coeff
		if velocity.x > friction * MIN_SPEED:
			velocity.x = velocity.x - friction * MIN_SPEED
		elif velocity.x > 0:
			velocity.x = 0 
		elif velocity.x < -friction * MIN_SPEED:
			velocity.x = velocity.x + friction * MIN_SPEED
		elif velocity.x < 0:
			velocity.x = 0
			
		if velocity != Vector2.ZERO:
			velocity = move_and_slide(velocity, Vector2.UP)
		
		# Handle the collisions with other objects
		for i in range(get_slide_count()):
			var collision = get_slide_collision(i)
			if not collision.collider: continue
			if collision.collider.has_method("collide_with"):
				collision.collider.collide_with(collision, self)
				
	# Kill out of screen
	if not (-20 < position.x and position.x < 360 + 20 and position.y < 180 + 20):
		kill()



func picking_up_box(pusher : KinematicBody2D):
	picked_up = true;
	self.position = pusher.position + Vector2(0,-15)
	pusher.picking_up_box(self)

func putting_down(direction):
	picked_up = false;
	velocity.x = direction * MAX_SPEED
	velocity.y = 0

func box_following_player(pusher : KinematicBody2D):
	self.position = pusher.position + Vector2(0,-15)

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

func _on_PlayerHoldingBox_body_exited(body):
	if body.get("TYPE") == "player" && picked_up :
		print("A")
		body.putting_down_box(0);

func kill():
	position = Vector2(spawn_position)
	$BreakSound.play()
	$Animation.play("spawn")

extends KinematicBody2D

const Utils = preload("utils.gd")

const TYPE = "player"

const ACCELERATION = 512
const JUMP_IMPULSE = 100
const AIR_FRICTION = 0.03
const SNAP = 2

const GROUND_FRICTION = 0.4
const MAX_SPEED = 64

var last_velocity = Vector2.ZERO
var velocity = Vector2.ZERO
var acceleration = ACCELERATION;
var is_jumping = false
var box_on_shoulder = false
var object_picked = KinematicBody2D

onready var sprite = $Sprite
onready var animationplayer = $Animation

var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2(200,0))
	Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY, 200)


func _physics_process(delta):
	# Player inputs
	if dead:
		return
	
	var GRAVITY = Utils.get_gravity(self)
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if box_on_shoulder :
		acceleration = ACCELERATION - (1+((GRAVITY-50)/250))
		clamp(acceleration, 32, ACCELERATION)
		object_picked.box_following_player(velocity)
		if GRAVITY >= 250 :
			self.kill()
		if Input.is_action_just_pressed("ui_w"):
			var direction = 0
			if sprite.is_flipped_h() :
				direction = -1
			else :
				direction = 1
			putting_down_box(direction)
	if x_input != 0:
		velocity.x += x_input * acceleration * delta
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
		
		sprite.flip_h = (x_input < 0)

	var friction
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -JUMP_IMPULSE
			is_jumping = true
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
			
	if velocity.y > 0:
		is_jumping = false
	
	if x_input == 0:
		velocity.x = lerp(velocity.x, 0, friction)

	velocity.y += GRAVITY * delta
	
	# To avoid sliding on the moving platforms
	var snap = Vector2.DOWN * SNAP if !is_jumping else Vector2.ZERO
	
	last_velocity = Vector2(velocity)
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, false, 4, PI/4, false)

	# Handle the collisions with other objects
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.collider.has_method("collide_with"):
			collision.collider.collide_with(collision, self)

		if collision.collider.has_method("push"):
			collision.collider.push(velocity, snap, self)

	if not (-10 < position.x and position.x < 360 + 10 and -10 < position.y and position.y < 180 + 10):
		kill()

func kill():
	putting_down_box(0)
	dead = true
	animationplayer.play("death")
	$DeathText.visible = true
	$DeathText.set_global_position(Vector2(160, 90) - $DeathText.rect_size / 2.0)
	$DeathSound.play()

func picking_up_box(object : KinematicBody2D):
	box_on_shoulder = true
	object_picked = object

func putting_down_box(direction):
	box_on_shoulder = false
	object_picked.putting_down(direction)
	acceleration = ACCELERATION;



func _on_Animation_finished(anim_name):
	if anim_name == "death":
		PlayerVariables.mort += 1
		get_tree().reload_current_scene()
		
		

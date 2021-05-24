extends KinematicBody2D

const Utils = preload("utils.gd")

const TYPE = "player"

const ACCELERATION = 512
const JUMP_IMPULSE = 100
const AIR_FRICTION = 0.03
const SNAP = 1.5

const GROUND_FRICTION = 0.4
const MAX_SPEED = 64

var last_velocity = Vector2.ZERO
var velocity = Vector2.ZERO
var acceleration = ACCELERATION;
var is_jumping = false
var box_on_shoulder = false
var object_picked = null

onready var sprite = $Sprite
onready var animationplayer = $Animation

var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, Vector2(200,0))
	Physics2DServer.area_set_param(get_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY, 200)


func handle_input():
	if Input.is_key_pressed(KEY_K):
		kill()
		
	for lvl in range(1, 4):
		# 48 is KEY_0
		if Input.is_key_pressed(48 + lvl):
			get_tree().change_scene("res://Level%s.tscn" % lvl)


func _physics_process(delta):
	handle_input()
	if dead:
		return
	
	var GRAVITY = Utils.get_gravity(self)
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var gravity_effort = lerp(1.5, 0.5, (GRAVITY - 100) / 300)
	
	if x_input != 0:
		velocity.x += x_input * acceleration * delta * gravity_effort
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
		
		sprite.flip_h = (x_input < 0)

	var friction
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -JUMP_IMPULSE * 1.0 if !box_on_shoulder else -JUMP_IMPULSE / 1.5
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
	update_box()
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP)
	# Handle the collisions with other objects
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.collider.has_method("collide_with"):
			collision.collider.collide_with(collision, self)

		if collision.collider.has_method("push"):
			collision.collider.push(velocity, snap, self)
			
	# Kill out of screen
	if not (-10 < position.x and position.x < 360 + 10 and -10 < position.y):
		kill()


func update_box():
	var gravity = Utils.get_gravity(self)
	if box_on_shoulder:
		if gravity > 250:
			kill()
			return
		
		acceleration = lerp(0, ACCELERATION,  (300.0 - gravity) / 300)
		object_picked.box_following_player(self)
		print("P ", self.position, " A ", acceleration)
		if Input.is_action_just_pressed("ui_w"):
			var direction = 0
			if sprite.is_flipped_h() :
				direction = -1
			else:
				direction = 1
			putting_down_box(direction)


func kill():
	putting_down_box(0)
	if dead:
		return
		
	dead = true
	animationplayer.play("death")
	$DeathText.visible = true
	$DeathText.set_global_position(Vector2(160, 90) - $DeathText.rect_size / 2.0)
	$DeathSound.play()

func picking_up_box(object : KinematicBody2D):
	box_on_shoulder = true
	object_picked = object

func putting_down_box(direction):
	if object_picked == null:
		return
		
	box_on_shoulder = false
	object_picked.putting_down(direction)
	acceleration = ACCELERATION;


func _on_Animation_finished(anim_name):
	if anim_name == "death":
		PlayerVariables.mort += 1
		get_tree().reload_current_scene()

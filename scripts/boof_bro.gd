extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -350.0
@onready var animated_sprite_player = $AnimatedSprite2D
@onready var boof_arm = $BoofArm
var animated_sprite_arm
var muzzle_location
var muzzle_node
var can_shoot = true
var facing_dir = 1

func load_resources():
	animated_sprite_arm = boof_arm.get_node("AnimatedSprite2D")
	muzzle_node = animated_sprite_arm.get_node("MuzzleNode")
	muzzle_location = muzzle_node.get_node("MuzzleLocation")

func _ready():
	load_resources()

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GameManager.GRAVITY * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		animated_sprite_player.play("run")
		velocity.x = direction * SPEED
		aim(direction)
	else:
		animated_sprite_player.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	GameManager.process_projectiles(delta)
	move_and_slide()
	
	
	
func aim(dir):
	if dir >= 0:
		animated_sprite_player.flip_h = false
		animated_sprite_arm.flip_v = false
		muzzle_node.scale.y = 1
		facing_dir = 1
	if dir == -1:
		animated_sprite_player.flip_h = true
		animated_sprite_arm.flip_v = true
		muzzle_node.scale.y = -1
		facing_dir = -1

func _input(event):
	
	if event.is_action_pressed("fire_1"):
		GameManager.add_new_bullet(
			animated_sprite_arm.global_position, 
			animated_sprite_arm.global_rotation,
			facing_dir
		)
		can_shoot = false
	if event.is_action_released("fire_1"):
		can_shoot = true

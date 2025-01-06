extends RigidBody2D
signal MuzzleBlocked

const ACC = 50000.0
const MAX_SPEED = 150
const JUMP_IMPULSE = 400.0
@onready var animated_sprite_player = $AnimatedSprite2D
@onready var boof_arm = $BoofArm
@onready var floor_rays: Node = $FloorRays
var animated_sprite_arm
var muzzle_location
var muzzle_node
var trigger_pulled = true
var facing_dir = 1
@onready var down_ray: RayCast2D = $DownRay
@onready var down_ray_2: RayCast2D = $DownRay2

func load_resources():
	animated_sprite_arm = boof_arm.get_node("AnimatedSprite2D")
	muzzle_node = animated_sprite_arm.get_node("MuzzleNode")
	muzzle_location = muzzle_node.get_node("MuzzleLocation")

func _ready():
	load_resources()
	gravity_scale = GameManager.get_gravity_scale()

func _physics_process(delta):
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if down_ray.is_colliding() or down_ray_2.is_colliding():
			apply_central_impulse(Vector2(0, -JUMP_IMPULSE))

	var direction = Input.get_axis("left", "right")
	if direction:
		animated_sprite_player.play("run")
		aim(direction)
		if !((sign(direction) == sign(linear_velocity.x)) && abs(linear_velocity.x) > MAX_SPEED):
			apply_central_force(Vector2(direction*ACC*delta, 0))
	else:
		var x_damping = -sign(linear_velocity.x)*delta*750*abs(linear_velocity.x)
		apply_central_force(Vector2(x_damping, 0))
		animated_sprite_player.play("idle")

	GameManager.process_projectiles(delta)

	
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
		if !GameManager.player_info_live["muzzle_blocked"]:
			GameManager.add_new_bullet(
				animated_sprite_arm.global_position, 
				animated_sprite_arm.global_rotation,
				facing_dir
			)
		trigger_pulled = true
	if event.is_action_released("fire_1"):
		trigger_pulled = false

extends RigidBody2D
signal MuzzleBlocked

const ACC = 50000.0
const MAX_SPEED = 150
const JUMP_IMPULSE = 400.0
const LEVEL_POS_MAP: Dictionary = {
	"Level1_base": Vector2(-213,-126),
	"Level1_cp": Vector2(0,0),
	"Level2_base": Vector2(-213,-126),
	"Level2_cp": Vector2(0,0)
}
var animated_sprite_arm
var muzzle_location
var muzzle_node
var trigger_pulled = true
var facing_dir = 1
var heal_cooldown = 0.5


@onready var animated_sprite_player = $AnimatedSprite2D
@onready var boof_arm = $BoofArm
@onready var floor_rays: Node = $FloorRays
@onready var down_ray: RayCast2D = $DownRay
@onready var down_ray_2: RayCast2D = $DownRay2

func load_resources():
	animated_sprite_arm = boof_arm.get_node("AnimatedSprite2D")
	muzzle_node = animated_sprite_arm.get_node("MuzzleNode")
	muzzle_location = muzzle_node.get_node("MuzzleLocation")

func _ready():
	load_resources()
	set_level_pos()
	gravity_scale = GameManager.get_gravity_scale()
	GameManager.set_boofbro(self)

func _process(delta: float) -> void:
	if heal_cooldown >= 0:
		heal_cooldown -= delta
	if GameManager.player_info_live.health < 0:
		set_collision_mask_value(1,false)

func set_level_pos():
	var cp_reached = GameManager.checkpoint_reached
	var level_num = get_tree().current_scene.name
	var pos_key
	if cp_reached:
		pos_key = level_num + '_cp'
	else:
		pos_key = level_num + "_base"
	position = LEVEL_POS_MAP[pos_key]
	

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


func _on_body_entered(body: Node) -> void:
	if "projectiles" in body.get_groups() && heal_cooldown < 0:
		heal_cooldown = 0.5
		GameManager.decrement_boofbro_health(1)

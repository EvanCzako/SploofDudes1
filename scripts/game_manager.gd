extends Node

@onready var bullets: Node = $Bullets
@onready var shurikens: Node = $Shurikens
var GRAVITY_SCALE = 1
@export var player_info_live: Dictionary = {
	"muzzle_blocked": false,
	"health": 3
}

func get_gravity_scale():
	return GRAVITY_SCALE

func add_new_bullet(pos: Vector2, rot: float, dir: float, speed: float = 300):
	var bullet_instance := Bullet.new_bullet(
		pos, 
		rot,
		dir,
		speed
	)
	bullets.add_child(bullet_instance)
	
func add_new_shurry(owner: RigidBody2D, pos: Vector2, rot: float, dir: float, speed: float = 300, rot_speed: float = 30):
	
	var shurry_instance := Shuriken.new_shuriken(
		owner,
		pos, 
		rot,
		dir,
		speed,
		rot_speed
	)
	shurikens.add_child(shurry_instance)	

func process_projectiles(delta: float):
	for bullet: Bullet in bullets.get_children():
		Bullet.process_bullet(bullet, delta)
	for shurry: Shuriken in shurikens.get_children():
		Shuriken.process_shurry(shurry, delta)


func print_vars():
	print("===========================")
	print(player_info_live)

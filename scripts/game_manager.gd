extends Node

@onready var bullets: Node = $Bullets
@onready var shurikens: Node = $Shurikens
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

func get_gravity():
	return GRAVITY

func add_new_bullet(pos: Vector2, rot: float, dir: float, speed: float = 250):

	var bullet_instance := Bullet.new_bullet(
		pos, 
		rot,
		dir,
		speed
	)
	bullets.add_child(bullet_instance)
	
func add_new_shurry(pos: Vector2, rot: float, dir: float, speed: float = 350):
	
	var shurry_instance := Shuriken.new_shuriken(
		pos, 
		rot,
		dir,
		speed
	)
	shurikens.add_child(shurry_instance)	

func process_projectiles(delta: float):
	for bullet: Bullet in bullets.get_children():
		Bullet.process_bullet(bullet, delta)
	for shurry: Shuriken in shurikens.get_children():
		Shuriken.process_shurry(shurry, delta)


func print_vars():
	print(bullets)
	print(shurikens)

extends Node

var BOOFBRO: RigidBody2D
@onready var bullets: Node = $Bullets
@onready var shurikens: Node = $Shurikens
@export var GRAVITY_SCALE = 1
@export var player_info_live: Dictionary

func reset_inits():
	Engine.time_scale = 1
	bullets = $Bullets
	shurikens = $Shurikens
	player_info_live = {
		"muzzle_blocked": false,
		"health": 3,
		"dying": false,
		"death_counter": 1.5
	}
	
func _ready() -> void:
	reset_inits()
	

func set_boofbro(bro: RigidBody2D):
	BOOFBRO = bro

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

func _process(delta: float) -> void:
	process_projectiles(delta)
	process_game_logic(delta)

func process_projectiles(delta: float):
	for bullet: Bullet in bullets.get_children():
		Bullet.process_bullet(bullet, delta)
	for shurry: Shuriken in shurikens.get_children():
		Shuriken.process_shurry(shurry, delta)

func clear_items():
	for bullet: Bullet in bullets.get_children():
		bullet.queue_free()
	for shurry: Shuriken in shurikens.get_children():
		shurry.queue_free()

func process_game_logic(delta: float):
	if player_info_live["dying"]:
		player_info_live["death_counter"] -= delta
		if player_info_live["death_counter"] < 0:
			clear_items()
			get_tree().reload_current_scene()
			reset_inits()

func decrement_boofbro_health(amount: float):
	player_info_live["health"] -= amount
	if player_info_live.health <= 0:
		Engine.time_scale = 0.5
		BOOFBRO.set_collision_mask_value(1, false)
		BOOFBRO.set_collision_mask_value(3, false)
		player_info_live["dying"] = true

func print_vars():
	print("===========================")
	print(player_info_live)

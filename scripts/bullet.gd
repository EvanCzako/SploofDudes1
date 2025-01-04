class_name Bullet
extends Node2D
const bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")
var speed: float

static func new_bullet(pos, rot, player_dir: float, speed: float) -> Bullet:
	var new_bullet: Bullet = bullet_scene.instantiate()
	new_bullet.speed = speed
	new_bullet.global_rotation = rot
	var init_offset
	if(player_dir >= 0):
		init_offset = Vector2(10, -2)
	else:
		init_offset = Vector2(10, 2)
	new_bullet.global_position = pos + init_offset.rotated(rot)
	return new_bullet

static func process_bullet(bullet: Bullet, delta: float):
	if !bullet:
		return
	
	var move_vec = Vector2(bullet.speed, 0).rotated(bullet.global_rotation)
	var bullet_raycast: RayCast2D = bullet.get_node("BulletSprite").get_node("BulletRaycast")
	if(bullet_raycast.is_colliding()):
		var collision_point = bullet_raycast.get_collision_point()
		var bullet_collider = bullet_raycast.get_collider()
		bullet.queue_free()
		
	
	bullet.global_position += move_vec * delta
	

class_name Bullet
extends RigidBody2D
const bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")
var speed: float
var deactivated: bool = false
var disappear_time: float = 3.0

static func new_bullet(pos, rot, player_dir: float, speed: float) -> Bullet:
	var new_bullet: Bullet = bullet_scene.instantiate()
	var bullet_raycast: RayCast2D = new_bullet.get_node("CollisionShape2D").get_node("BulletRaycast")
	bullet_raycast.add_exception(new_bullet)
	var impulse_vector = Vector2(speed,0).rotated(rot)
	new_bullet.global_rotation = rot
	var init_offset
	if(player_dir >= 0):
		init_offset = Vector2(10, -2)
	else:
		init_offset = Vector2(10, 2)
	new_bullet.global_position = pos + init_offset.rotated(rot)
	new_bullet.apply_central_impulse(impulse_vector)
	return new_bullet

static func process_bullet(bullet: Bullet, delta: float):
	if !bullet:
		return
	
	if bullet.deactivated:
		bullet.disappear_time -= delta
		if bullet.disappear_time <= 0:
			bullet.queue_free()
			pass
	else:
		if bullet.get_contact_count() > 0:
			for body in bullet.get_colliding_bodies():
				if body.name != "BoofBro":
					bullet.gravity_scale = 1
					bullet.deactivated = true
					bullet.set_collision_layer_value(1, false)
					bullet.set_collision_mask_value(1, false)

	

class_name Shuriken
extends RigidBody2D
const shuriken_scene: PackedScene = preload("res://scenes/shuriken.tscn")
var deactivated: bool = false
var disappear_time: float = 3.0
var owning_ninja: RigidBody2D

static func new_shuriken(owning_ninja, pos, rot, ninja_dir: float, speed: float, rot_speed: float) -> Shuriken:
	var new_shurry: Shuriken = shuriken_scene.instantiate()
	new_shurry.owning_ninja = owning_ninja
	new_shurry.rotation_degrees = randf_range(0,90)
	var impulse_vector = Vector2(speed,0).rotated(rot)
	var init_offset
	if(ninja_dir >= 0):
		init_offset = Vector2(10, -2)
	else:
		init_offset = Vector2(-10, 2)
		rot = PI - rot
	new_shurry.global_position = pos + init_offset
	new_shurry.apply_central_impulse(impulse_vector)
	new_shurry.apply_torque_impulse(rot_speed)
	
	return new_shurry

static func process_shurry(shurry: Shuriken, delta: float):
	
	if !shurry:
		return
	
	if shurry.deactivated:
		shurry.disappear_time -= delta
		if shurry.disappear_time <= 0:
			shurry.queue_free()
			pass
	else:
		if shurry.get_contact_count() > 0:
			for body in shurry.get_colliding_bodies():
				if body != shurry.owning_ninja:
					shurry.gravity_scale = 1
					shurry.deactivated = true
					shurry.set_collision_layer_value(1, false)
					shurry.set_collision_mask_value(1, false)

	

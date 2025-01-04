class_name Shuriken
extends Node2D
const shuriken_scene: PackedScene = preload("res://scenes/shuriken.tscn")
var speed: float
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

static func new_shuriken(pos, rot, ninja_dir: float, speed: float) -> Shuriken:
	var new_shurry: Shuriken = shuriken_scene.instantiate()
	new_shurry.speed = speed
	new_shurry.rotation_degrees = randf_range(0,90)
	var init_offset
	if(ninja_dir >= 0):
		init_offset = Vector2(20, -2)
	else:
		init_offset = Vector2(-20, 2)
		rot = PI - rot
	new_shurry.velocity = Vector2(1,0).rotated(-rot)*speed
	new_shurry.global_position = pos + init_offset
	
	return new_shurry

static func process_shurry(shurry: Shuriken, delta: float):
	
	if !shurry:
		return
	
	
	shurry.velocity.y += GameManager.get_gravity() * delta
	shurry.move_and_slide()

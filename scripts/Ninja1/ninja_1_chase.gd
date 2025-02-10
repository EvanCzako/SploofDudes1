extends EnemyState
class_name Ninja1Chase

@export var ninja: RigidBody2D
@export var ninja_animation: AnimatedSprite2D
@export var ninja_forward_raycast: RayCast2D
@export var MAX_SPEED = randf_range(90, 130)
@export var boofbro_raycast: RayCast2D

const JUMP_IMPULSE = 650.0
var ACC = 60000
var is_jumping: bool = false
var jump_cooldown = 0.25
var boof_bro: RigidBody2D

var move_direction: float
var undetect_time: float
var shuriken_time: float = randf_range(1,3)

func reset_shuriken_time():
	shuriken_time = randf_range(1,3)
	
func Enter():
	boof_bro = get_tree().get_first_node_in_group("Player")
	ninja_animation.play("chase")
	
func Update(delta: float):
	pass
		
func PhysicsUpdate(delta: float):
	if !ninja:
		return
		
	if abs(ninja.linear_velocity.y) > 1:
		ninja_animation.play("jump")
	else:
		ninja_animation.play("chase")
	
	jump_cooldown -= delta
	if is_jumping and abs(ninja.linear_velocity.y) < 0.1:
		for body in ninja.get_colliding_bodies():
			if "MapCollision" in body.get_groups() or "environment" in body.get_groups():
				is_jumping = false
				jump_cooldown = 0.5
	
	if ninja_forward_raycast.is_colliding() and !is_jumping and jump_cooldown < 0:
		if "MapCollision" in ninja_forward_raycast.get_collider().get_groups() or "environment" in ninja_forward_raycast.get_collider().get_groups():
			is_jumping = true
			ninja.apply_central_impulse(Vector2(0,-JUMP_IMPULSE))
	
	
	shuriken_time -= delta
	var dir_to_boof_bro = sign(boof_bro.position.x - ninja.position.x)
	var distance_from_player = ninja.position.distance_to(boof_bro.position)
	ninja_animation.flip_h = dir_to_boof_bro >= 0
	if dir_to_boof_bro > 0:
		ninja_forward_raycast.target_position = Vector2(25,0)
	else:
		ninja_forward_raycast.target_position = Vector2(-25,0)
	
	if !((sign(dir_to_boof_bro) == sign(ninja.linear_velocity.x)) && abs(ninja.linear_velocity.x) > MAX_SPEED):
		ninja.apply_central_force(Vector2(dir_to_boof_bro*ACC*delta, 0))
	else:
		pass

	if shuriken_time < 0:
		var shurry_rot
		if dir_to_boof_bro >= 0:
			shurry_rot = -PI/6
		else:
			shurry_rot = PI + PI/6
		shurry_rot = shurry_rot + randf_range(-PI/12, PI/12)
		GameManager.add_new_shurry(ninja, ninja.position, shurry_rot, dir_to_boof_bro)
		reset_shuriken_time()

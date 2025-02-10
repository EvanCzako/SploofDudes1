extends EnemyState
class_name BigGuy1Chase

@export var big_guy: RigidBody2D
@export var big_guy_animation: AnimatedSprite2D
@export var big_guy_raycast: RayCast2D
@export var MAX_SPEED = randf_range(90, 130)
@export var boofbro_raycast: RayCast2D

const JUMP_IMPULSE = 650.0
var ACC = 60000
var is_jumping: bool = false
var jump_cooldown = 0.25
var boof_bro: RigidBody2D

var move_direction: float
var undetect_time: float
	
func Enter():
	boof_bro = get_tree().get_first_node_in_group("Player")
	big_guy_animation.play("chase")
	
func Update(delta: float):
	pass
		
func PhysicsUpdate(delta: float):
	if !big_guy:
		return
		
	if abs(big_guy.linear_velocity.y) > 1:
		big_guy_animation.play("jump")
	else:
		big_guy_animation.play("chase")
	
	jump_cooldown -= delta
	if is_jumping and abs(big_guy.linear_velocity.y) < 0.1:
		for body in big_guy.get_colliding_bodies():
			if "MapCollision" in body.get_groups() or "environment" in body.get_groups():
				is_jumping = false
				jump_cooldown = 0.5
	
	if big_guy_raycast.is_colliding() and !is_jumping and jump_cooldown < 0:
		if "MapCollision" in big_guy_raycast.get_collider().get_groups() or "environment" in big_guy_raycast.get_collider().get_groups():
			is_jumping = true
			big_guy.apply_central_impulse(Vector2(0,-JUMP_IMPULSE))

	
	
	var dir_to_boof_bro = sign(boof_bro.position.x - big_guy.position.x)
	var distance_from_player = big_guy.position.distance_to(boof_bro.position)
	big_guy_animation.flip_h = dir_to_boof_bro >= 0
	if dir_to_boof_bro > 0:
		big_guy_raycast.target_position = Vector2(25,0)
	else:
		big_guy_raycast.target_position = Vector2(-25,0)
	
	if !((sign(dir_to_boof_bro) == sign(big_guy.linear_velocity.x)) && abs(big_guy.linear_velocity.x) > MAX_SPEED):
		big_guy.apply_central_force(Vector2(dir_to_boof_bro*ACC*delta, 0))
	else:
		pass

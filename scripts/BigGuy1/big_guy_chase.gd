extends EnemyState
class_name BigGuy1Chase

@export var big_guy: RigidBody2D
@export var big_guy_animation: AnimatedSprite2D
@export var big_guy_raycast: RayCast2D
@export var MAX_SPEED = randf_range(130, 170)
@export var boofbro_raycast: RayCast2D
@export var boom_collision: CollisionShape2D

const JUMP_IMPULSE = 750.0
var ACC = 40000
var is_jumping: bool = false
var jump_cooldown = 0.1
var boof_bro: RigidBody2D

var move_direction: float
var undetect_time: float
var boof_bro_boomable: bool = false
var end_boom_cycle: bool = false
var boom_magnitude: float = 500
var dir_to_boof_bro: float = 0
	
func Enter():
	boof_bro = get_tree().get_first_node_in_group("Player")
	big_guy_animation.play("chase")
	
func Update(delta: float):
	if big_guy_animation.get_frame() == 0:
		end_boom_cycle = false
	if big_guy_animation.get_frame() >= 6 and boof_bro_boomable and !end_boom_cycle:
		var boom_vec = Vector2(0, -boom_magnitude)
		boof_bro.apply_central_impulse(boom_vec)
		GameManager.decrement_boofbro_health(2)
		end_boom_cycle = true
		
		
func PhysicsUpdate(delta: float):

	if !big_guy:
		return
	
	jump_cooldown -= delta
	if is_jumping and abs(big_guy.linear_velocity.y) < 0.1:
		for body in big_guy.get_colliding_bodies():
			if "MapCollision" in body.get_groups() or "environment" in body.get_groups():
				is_jumping = false
				jump_cooldown = 0.1
	
	if big_guy_raycast.is_colliding() and !is_jumping and jump_cooldown < 0:
		if "MapCollision" in big_guy_raycast.get_collider().get_groups() or "environment" in big_guy_raycast.get_collider().get_groups():
			is_jumping = true
			big_guy.apply_central_impulse(Vector2(0,-JUMP_IMPULSE))

	dir_to_boof_bro = sign(boof_bro.position.x - big_guy.position.x)
	var distance_from_player = big_guy.position.distance_to(boof_bro.position)
	big_guy_animation.flip_h = dir_to_boof_bro >= 0
	if dir_to_boof_bro >= 0:
		boom_collision.position.x = 18.5
	else:
		boom_collision.position.x = -18.5
	if dir_to_boof_bro > 0:
		big_guy_raycast.target_position = Vector2(25,0)
	else:
		big_guy_raycast.target_position = Vector2(-25,0)
	
	if !((sign(dir_to_boof_bro) == sign(big_guy.linear_velocity.x)) && abs(big_guy.linear_velocity.x) > MAX_SPEED):
		big_guy.apply_central_force(Vector2(dir_to_boof_bro*ACC*delta, 0))
	else:
		pass


func _on_boom_area_body_entered(body: Node2D) -> void:
	if body.name == "BoofBro":
		boof_bro_boomable = true


func _on_boom_area_body_exited(body: Node2D) -> void:
	if body.name == "BoofBro":
		boof_bro_boomable = false

extends EnemyState
class_name BigGuy1Idle

@export var big_guy: RigidBody2D
@export var move_speed := 40.0
@export var big_guy_animation: AnimatedSprite2D
@export var boofbro_raycast: RayCast2D
@export var big_guy_raycast: RayCast2D

const ACC = 70000.0
var boof_bro: RigidBody2D
var turn_cooldown: float = 0.25
var move_direction: float
var wander_time: float

func randomize_wander():
	move_direction = round(randf_range(-1.49, 1.49))
	wander_time = randf_range(2, 4)
	
func Enter():
	big_guy_animation.play("idle_still")
	boof_bro = get_tree().get_first_node_in_group("Player")
	randomize_wander()
	
func Exit():
	pass
	
func Update(delta: float):
	if turn_cooldown > 0:
		turn_cooldown -= delta
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()
		
func PhysicsUpdate(delta: float):
	if big_guy:
		var dir_to_boof_bro = sign(boof_bro.position.x - big_guy.position.x)
		var distance_from_player = big_guy.position.distance_to(boof_bro.position)
		if move_direction < 0:
			big_guy_animation.flip_h = false
			big_guy_animation.play("idle_walk")
			big_guy_raycast.target_position = Vector2(-25,0)
		elif move_direction > 0:
			big_guy_animation.flip_h = true
			big_guy_animation.play("idle_walk")
			big_guy_raycast.target_position = Vector2(25,0)
		elif move_direction == 0:
			var x_damping = -sign(big_guy.linear_velocity.x)*delta*1000*abs(big_guy.linear_velocity.x)
			big_guy.apply_central_force(Vector2(x_damping, 0))
			big_guy_animation.play("idle_still")
		
		if (abs(big_guy.linear_velocity.x) < move_speed) or (sign(big_guy.linear_velocity.x) != move_direction):
			big_guy.apply_central_force(Vector2(move_direction*ACC*delta, 0))

		# Check for walls
		if big_guy_raycast.is_colliding() and turn_cooldown < 0:
			if ("environment" in big_guy_raycast.get_collider().get_groups()) or \
			("MapCollision" in big_guy_raycast.get_collider().get_groups()):
				move_direction *= -1
				turn_cooldown = 0.25

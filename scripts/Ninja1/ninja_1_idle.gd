extends EnemyState
class_name Ninja1Idle

@export var ninja: RigidBody2D
@export var move_speed := 40.0
@export var ninja_animation: AnimatedSprite2D
@export var boofbro_raycast: RayCast2D
@export var ninja_raycast: RayCast2D

const ACC = 70000.0
var boof_bro: RigidBody2D
var turn_cooldown: float = 0.25
var move_direction: float
var wander_time: float

func randomize_wander():
	move_direction = round(randf_range(-1.49, 1.49))
	wander_time = randf_range(2, 4)
	
func Enter():
	ninja_animation.play("idle")
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
	
	if ninja:
		var dir_to_boof_bro = sign(boof_bro.position.x - ninja.position.x)
		var distance_from_player = ninja.position.distance_to(boof_bro.position)
		if move_direction < 0:
			ninja_animation.flip_h = false
			ninja_animation.play("chase")
			ninja_raycast.target_position = Vector2(-25,0)
		elif move_direction > 0:
			ninja_animation.flip_h = true
			ninja_animation.play("chase")
			ninja_raycast.target_position = Vector2(25,0)
		elif move_direction == 0:
			var x_damping = -sign(ninja.linear_velocity.x)*delta*1000*abs(ninja.linear_velocity.x)
			ninja.apply_central_force(Vector2(x_damping, 0))
			ninja_animation.play("idle")
		
		if (abs(ninja.linear_velocity.x) < move_speed) or (sign(ninja.linear_velocity.x) != move_direction):
			ninja.apply_central_force(Vector2(move_direction*ACC*delta, 0))

		# Check for walls
		if ninja_raycast.is_colliding() and turn_cooldown < 0:
			if ("environment" in ninja_raycast.get_collider().get_groups()) or \
			("MapCollision" in ninja_raycast.get_collider().get_groups()):
				move_direction *= -1
				turn_cooldown = 0.25

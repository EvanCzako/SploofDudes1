extends EnemyState
class_name Ninja1Idle

@export var ninja: RigidBody2D
@export var move_speed := 40.0
@export var ninja_animation: AnimatedSprite2D
const ACC = 70000.0
var boof_bro: RigidBody2D

var move_direction: float
var wander_time: float

func randomize_wander():
	move_direction = round(randf_range(-1.49, 1.49))
	wander_time = randf_range(2, 4)
	
func Enter():
	ninja_animation.play("idle")
	ninja.set_sleeping(true)
	ninja.set_sleeping(false)
	boof_bro = get_tree().get_first_node_in_group("Player")
	randomize_wander()
	
func Exit():
	print("Exit idle called")
	
func Update(delta: float):
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
		elif move_direction > 0:
			ninja_animation.flip_h = true
			ninja_animation.play("chase")
		elif move_direction == 0:
			ninja_animation.play("idle")
		if distance_from_player < 200:
			Transitioned.emit(self, "Ninja1Chase")
		
		if(abs(ninja.linear_velocity.x) < move_speed):
			ninja.apply_central_force(Vector2(move_direction*ACC*delta, 0))

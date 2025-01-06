extends EnemyState
class_name Ninja1Idle

@export var ninja: CharacterBody2D
@export var move_speed := 40.0
@export var ninja_animation: AnimatedSprite2D
var boof_bro: RigidBody2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

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
		if ninja.velocity.x < 0:
			ninja_animation.flip_h = false
			ninja_animation.play("chase")
		elif ninja.velocity.x > 0:
			ninja_animation.flip_h = true
			ninja_animation.play("chase")
		elif ninja.velocity.x == 0:
			ninja_animation.play("idle")
		if distance_from_player < 200:
			Transitioned.emit(self, "Ninja1Chase")
		
		ninja.velocity.x = move_direction * move_speed
		if not ninja.is_on_floor():
			ninja.velocity.y += gravity * delta
		ninja.move_and_slide()

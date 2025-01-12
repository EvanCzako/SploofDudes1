extends EnemyState
class_name Ninja1Die

@export var ninja: RigidBody2D
@export var move_speed := 40.0
@export var ninja_animation: AnimatedSprite2D
const ACC = 70000.0
var boof_bro: RigidBody2D
var die_time: float
	
func Enter():
	ninja_animation.play("idle")
	ninja.set_collision_mask_value(2,false)
	
func Update(delta: float):
	pass
		
func PhysicsUpdate(delta: float):
	pass
	

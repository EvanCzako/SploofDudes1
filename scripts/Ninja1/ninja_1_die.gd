extends EnemyState
class_name Ninja1Die

@export var ninja: RigidBody2D
@export var ninja_animation: AnimatedSprite2D
var boof_bro: RigidBody2D
	
func Enter():
	ninja_animation.play("stunned")
	ninja.set_collision_mask_value(2,false)
	
func Update(delta: float):
	pass
		
func PhysicsUpdate(delta: float):
	pass
	

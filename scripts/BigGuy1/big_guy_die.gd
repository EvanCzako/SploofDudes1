extends EnemyState
class_name BigGuy1Die

@export var big_guy: RigidBody2D
@export var big_guy_animation: AnimatedSprite2D
var boof_bro: RigidBody2D

func Enter():
	big_guy_animation.play("stunned")
	big_guy.set_collision_mask_value(2,false)
	
func Update(delta: float):
	pass
		
func PhysicsUpdate(delta: float):
	pass
	

extends EnemyState
class_name Ninja1Stunned

@export var ninja: RigidBody2D
@export var move_speed := 40.0
@export var ninja_animation: AnimatedSprite2D
const ACC = 70000.0
var boof_bro: RigidBody2D
var stun_time: float
	
func Enter():
	stun_time = 1.0
	ninja_animation.play("stunned")
	
func Update(delta: float):
	stun_time -= delta
	if stun_time <= 0:
		Transitioned.emit(self, "Ninja1Chase")
		
func PhysicsUpdate(delta: float):
	pass
	

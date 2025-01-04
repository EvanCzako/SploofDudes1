extends EnemyState
class_name EnemyChase

@export var enemy: CharacterBody2D
@export var enemy_animation: AnimatedSprite2D
@export var move_speed := 80.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var horizontal_acc = 5
var boof_bro: CharacterBody2D

var move_direction: float
var undetect_time: float
	
func Enter():
	boof_bro = get_tree().get_first_node_in_group("Player")
	
func Update(delta: float):
	pass
		
func PhysicsUpdate(delta: float):
	if enemy:
		var dir_to_boof_bro = sign(boof_bro.position.x - enemy.position.x)
		var distance_from_player = enemy.position.distance_to(boof_bro.position)
		enemy_animation.flip_h = dir_to_boof_bro < 0
		if distance_from_player > 100:
			Transitioned.emit(self, "EnemyIdle")
		
		if (abs(enemy.velocity.x) < move_speed) or (sign(enemy.velocity.x) != dir_to_boof_bro):
			enemy.velocity.x += dir_to_boof_bro * horizontal_acc
		if not enemy.is_on_floor():
			enemy.velocity.y += gravity * delta
			
		#print(enemy.velocity)
		#print(move_speed)
		enemy.move_and_slide()

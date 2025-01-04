extends EnemyState
class_name EnemyIdle

@export var enemy: CharacterBody2D
@export var move_speed := 25.0
@export var enemy_animation: AnimatedSprite2D
var boof_bro: CharacterBody2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var move_direction: float
var wander_time: float

func randomize_wander():
	move_direction = round(randf_range(-1.49, 1.49))
	wander_time = randf_range(2, 4)
	
func Enter():
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
	
	
	if enemy:
		var dir_to_boof_bro = sign(boof_bro.position.x - enemy.position.x)
		var distance_from_player = enemy.position.distance_to(boof_bro.position)
		if enemy.velocity.x < 0:
			enemy_animation.flip_h = true
		elif enemy.velocity.x > 0:
			enemy_animation.flip_h = false
		if distance_from_player < 100:
			print(self.name)
			Transitioned.emit(self, "EnemyChase")
		
		enemy.velocity.x = move_direction * move_speed
		if not enemy.is_on_floor():
			enemy.velocity.y += gravity * delta
		enemy.move_and_slide()

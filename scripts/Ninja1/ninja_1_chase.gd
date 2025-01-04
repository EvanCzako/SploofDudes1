extends EnemyState
class_name Ninja1Chase

@export var ninja: CharacterBody2D
@export var ninja_animation: AnimatedSprite2D
@export var move_speed := 100.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var horizontal_acc = 5
var boof_bro: CharacterBody2D

var move_direction: float
var undetect_time: float
var shuriken_time: float = randf_range(1,3)

func reset_shuriken_time():
	shuriken_time = randf_range(1,3)
	
func Enter():
	boof_bro = get_tree().get_first_node_in_group("Player")
	ninja_animation.play("chase")
	
func Update(delta: float):
	pass
		
func PhysicsUpdate(delta: float):
	if !ninja:
		return

	shuriken_time -= delta
	var dir_to_boof_bro = sign(boof_bro.position.x - ninja.position.x)
	var distance_from_player = ninja.position.distance_to(boof_bro.position)
	ninja_animation.flip_h = dir_to_boof_bro >= 0
	if distance_from_player > 200:
		Transitioned.emit(self, "Ninja1Idle")
	
	if (abs(ninja.velocity.x) < move_speed) or (sign(ninja.velocity.x) != dir_to_boof_bro):
		ninja.velocity.x += dir_to_boof_bro * horizontal_acc
	if not ninja.is_on_floor():
		ninja.velocity.y += gravity * delta

	if shuriken_time < 0:
		GameManager.add_new_shurry(ninja.position, PI/4, dir_to_boof_bro)
		reset_shuriken_time()

	ninja.move_and_slide()

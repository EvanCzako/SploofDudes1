extends RigidBody2D

var is_punctured: bool = false
var time_to_boom: float = randf_range(1,2)
var explosion_time: float = 0.9
var explosion_impulse: float = 700
var boomed_bodies: Array = []
var puncture_force: float = 500
@onready var gas_fire: AnimatedSprite2D = $GasFire
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var explode_circle: Area2D = $ExplodeCircle


func _ready():
	gravity_scale = GameManager.get_gravity_scale()

func _integrate_forces(state) -> void:
	if is_punctured: 
		return
	var contact_count = state.get_contact_count()
	if contact_count > 0:
		for idx in range(contact_count):
			if state.get_contact_collider_object(idx).is_in_group("projectiles"):
				handle_puncture(state.get_contact_local_position(idx))
				break

func _process(delta: float) -> void:
	if is_punctured:
		if time_to_boom <= 0:
			collision_shape_2d.disabled = true
			handle_explode(delta)
		time_to_boom -= delta

func handle_puncture(puncture_pos):
	var propulsion_force
	is_punctured = true
	gas_fire.visible = true
	gas_fire.global_position = puncture_pos
	var puncture_vector = puncture_pos - (position + Vector2(0,-12))
	gas_fire.rotation = puncture_vector.angle()
	var propulsion_vector = -puncture_force*puncture_vector.normalized()
	add_constant_force(propulsion_vector, puncture_pos-position)
	gravity_scale = 0.3

func handle_explode(delta: float):
	for body in explode_circle.get_overlapping_bodies():
		if !(body in boomed_bodies):
			if body.name == "BoofBro" or "enemies" in body.get_groups():
				var boom_impulse = (body.global_position-global_position).normalized() * explosion_impulse
				body.apply_central_impulse(boom_impulse)
				boomed_bodies.append(body)
	
	freeze = true
	gas_fire.visible = false
	animation_player.play("explode")
	explosion_time -= delta
	if explosion_time > 0:
		return
	else:
		queue_free()

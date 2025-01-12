extends RigidBody2D

var is_punctured: bool = false
var time_to_boom: float = randf_range(1,2)
var explosion_time: float = 0.9
@onready var gas_fire: AnimatedSprite2D = $GasFire
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

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

func handle_puncture(local_pos):
	var propulsion_force
	is_punctured = true
	gas_fire.visible = true
	gas_fire.global_position = local_pos
	if local_pos.x > position.x:
		gas_fire.flip_h = true
		propulsion_force = Vector2(-500,0)
	else:
		gas_fire.flip_h = false
		propulsion_force = Vector2(500,0)
	add_constant_force(propulsion_force, local_pos-position)
	gravity_scale = 0.3

func handle_explode(delta: float):
	freeze = true
	gas_fire.visible = false
	animation_player.play("explode")
	explosion_time -= delta
	if explosion_time > 0:
		return
	else:
		queue_free()

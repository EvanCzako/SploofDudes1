extends RigidBody2D

var is_punctured: bool = false
@onready var gas_fire: AnimatedSprite2D = $GasFire

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
	
	print(local_pos)

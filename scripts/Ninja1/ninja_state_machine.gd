extends Node

@export var boofbro: RigidBody2D
@export var initial_state: EnemyState
@onready var bounce_head: RigidBody2D = $"../BounceHead"
@onready var ninja_1_die: Ninja1Die = $Ninja1Die
@onready var ninja_1_stunned: Ninja1Stunned = $Ninja1Stunned
@onready var boofbro_raycast: RayCast2D = $"../BoofBroRaycast"
@onready var ninja_1: RigidBody2D = $".."
@onready var ninja_1_chase: Ninja1Chase = $Ninja1Chase
@onready var ninja_1_idle: Ninja1Idle = $Ninja1Idle
@onready var ninja_forward_raycast: RayCast2D = $"../NinjaForwardRaycast"

var current_state: EnemyState
var states: Dictionary = {}
var health = 4
var dead = false
var can_see_boofbro: bool = false
var chase_cooldown: float = 2.5
var move_direction: float = 0.0
var sight_distance: float = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	boofbro = get_tree().get_first_node_in_group("Player")

	for child in get_children():
		if child is EnemyState:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state:
		current_state.Update(delta)
	process_game_logic(delta)

func _physics_process(delta):
	if current_state:
		current_state.PhysicsUpdate(delta)
	process_physics_logic(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	current_state = new_state


func process_game_logic(delta):
	if health < 0 && !dead:
		current_state.Exit()
		ninja_1_die.Enter()
		current_state = ninja_1_die
		dead = true
		
	if current_state == ninja_1_chase:
		chase_cooldown -= delta
		if !can_see_boofbro:
			if chase_cooldown <= 0:
				current_state.Exit()
				ninja_1_idle.Enter()
				current_state = ninja_1_idle
		else:
			chase_cooldown = 3
	
	if current_state == ninja_1_idle and can_see_boofbro:
		var ninja_rayvec = ninja_forward_raycast.target_position - ninja_forward_raycast.position
		var boof_rayvec = boofbro_raycast.target_position - boofbro_raycast.position
		if boof_rayvec.dot(ninja_rayvec) > 0 && boof_rayvec.length() < sight_distance:
			current_state.Exit()
			ninja_1_chase.Enter()
			current_state = ninja_1_chase
	#
func process_physics_logic(delta):
	boofbro_raycast.target_position = boofbro.global_position - ninja_1.global_position + Vector2(0,-5)
	boofbro_raycast.global_position = ninja_1.global_position
	
	if boofbro_raycast.get_collider() == boofbro:
		can_see_boofbro = true
	else:
		can_see_boofbro = false
		
func _on_bounce_head_body_entered(body: Node) -> void:
	health -= 2
	current_state.Exit()
	ninja_1_stunned.Enter()
	current_state = ninja_1_stunned

func _on_ninja_1_body_entered(body: Node) -> void:
	if "projectiles" in body.get_groups():
		if current_state != ninja_1_chase:
			current_state.Exit()
			ninja_1_chase.Enter()
			current_state = ninja_1_chase
		health -= 0.5

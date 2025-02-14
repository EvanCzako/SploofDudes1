extends Node

@export var boofbro: RigidBody2D
@export var initial_state: EnemyState
@onready var boofbro_raycast: RayCast2D = $"../BoofBroRaycast"
@onready var big_guy: RigidBody2D = $".."
@onready var big_guy_chase: BigGuy1Chase = $BigGuyChase
@onready var big_guy_idle: BigGuy1Idle = $BigGuyIdle
@onready var big_guy_raycast: RayCast2D = $"../BigGuyForwardRaycast"
@onready var big_guy_stunned: BigGuy1Stunned = $BigGuyStunned
@onready var big_guy_die: Node = $BigGuyDie

var current_state: EnemyState
var states: Dictionary = {}
var health: float = 10
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
		big_guy_die.Enter() 
		current_state = big_guy_die
		dead = true
		
	if current_state == big_guy_chase:
		chase_cooldown -= delta
		if !can_see_boofbro or (boofbro.global_position-big_guy.global_position).length() > 200:
			if chase_cooldown <= 0:
				current_state.Exit()
				big_guy_idle.Enter()
				current_state = big_guy_idle
		else:
			chase_cooldown = 3
	
	if (current_state == big_guy_idle) and can_see_boofbro:
		var big_guy_rayvec = big_guy_raycast.target_position - big_guy_raycast.position
		var boof_rayvec = boofbro_raycast.target_position - boofbro_raycast.position
		if boof_rayvec.dot(big_guy_rayvec) > 0 && boof_rayvec.length() < sight_distance:
			current_state.Exit()
			big_guy_chase.Enter()
			current_state = big_guy_chase
	
func process_physics_logic(delta):
	boofbro_raycast.target_position = (boofbro.global_position + Vector2(0,-30)) - \
	(big_guy.global_position + Vector2(0,-5))
	boofbro_raycast.global_position = big_guy.global_position
	
	if boofbro_raycast.get_collider() == boofbro:
		can_see_boofbro = true
	else:
		can_see_boofbro = false
		
func _on_bounce_head_body_entered(body: Node) -> void:
	health -= 2
	current_state.Exit()
	big_guy_stunned.Enter()
	current_state = big_guy_stunned


func _on_big_guy_1_body_entered(body: Node) -> void:
	if "projectiles" in body.get_groups() and !dead:
		if current_state != big_guy_chase:
			current_state.Exit()
			big_guy_chase.Enter()
			current_state = big_guy_chase
		health -= 0.5

extends Node

@export var initial_state: EnemyState
@onready var bounce_head: RigidBody2D = $"../BounceHead"
@onready var ninja_1_die: Ninja1Die = $Ninja1Die

var current_state: EnemyState
var states: Dictionary = {}
var health = 2
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
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
	
func process_physics_logic(delta):
	pass

func _on_bounce_head_body_entered(body: Node) -> void:
	health -= 1
	print(health)

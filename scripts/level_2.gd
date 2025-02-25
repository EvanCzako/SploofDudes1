extends Node2D

@onready var ninjas: Node = $Ninjas
@onready var big_guys: Node = $BigGuys

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var enemies: Array[Node] = []
	enemies.append_array(ninjas.get_children())
	enemies.append_array(big_guys.get_children())
	GameManager.add_collision_exceptions(enemies) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

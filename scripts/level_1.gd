extends Node2D

@onready var ninjas: Node = $Ninjas

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.add_collision_exceptions(ninjas.get_children()) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

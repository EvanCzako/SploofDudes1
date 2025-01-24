extends AnimatedSprite2D

var flicker_time: float = randf_range(3,7)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("idle")
	if randf() > 0.5:
		flip_h = true
	else:
		flip_h = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

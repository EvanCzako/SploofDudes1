extends AnimatedSprite2D

var flicker_time: float = randf_range(3,7)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	flicker_time -= delta
	if flicker_time < 0:
		play("flicker")
		flicker_time = randf_range(3,7)

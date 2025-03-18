extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !GameManager.checkpoint_reached:
		play("checkpoint_off")
	else:
		play("checkpoint_on")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !GameManager.checkpoint_reached:
		GameManager.checkpoint_reached = true
		play("checkpoint_on")

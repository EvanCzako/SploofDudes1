extends Sprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "BoofBro":
		GameManager.decrement_boofbro_health(-3)
		queue_free()

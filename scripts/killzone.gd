extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body.get_name() == "BoofBro":
		GameManager.player_info_live["dying"] = true
	else:
		body.queue_free()
		
#func _on_timer_timeout() -> void:
	#get_tree().reload_current_scene()

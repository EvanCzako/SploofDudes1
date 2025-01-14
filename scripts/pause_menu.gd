extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("RESET")

func resume():
	get_tree().paused = false
	animation_player.play_backwards("blur")
	
func pause():
	get_tree().paused = true
	animation_player.play("blur")
	
func testEsc():
	
	if Input.is_action_just_pressed("Pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("Pause") and get_tree().paused:
		resume()
		
		
func _process(delta: float) -> void:
	testEsc()

func _on_resume_button_pressed() -> void:
	resume()


func _on_level_button_pressed() -> void:
	pass # Replace with function body.


func _on_restart_button_pressed() -> void:
	GameManager.reset_inits()
	resume()
	get_tree().reload_current_scene()
	

func _on_quit_button_pressed() -> void:
	get_tree().quit()

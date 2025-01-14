extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var active = false

func _ready() -> void:
	animation_player.play("RESET")

func resume():
	get_tree().paused = false
	GameManager.menu_info["active_menu"] = null
	animation_player.play_backwards("blur")
	
func pause():
	get_tree().paused = true
	GameManager.menu_info["active_menu"] = "MENU_PAUSE"
	active = true
	print("FUCK")
	animation_player.play("blur")
	
func testEsc():
	
	if Input.is_action_just_pressed("Pause") and !get_tree().paused and \
	(GameManager.menu_info["active_menu"] != "MENU_PAUSE"):
		pause()
	elif Input.is_action_just_pressed("Pause") and get_tree().paused:
		resume()
		
		
func _process(delta: float) -> void:
	testEsc()

func _on_resume_button_pressed() -> void:
	if get_tree().paused:
		resume()

func _on_level_button_pressed() -> void:
	GameManager.menu_info["active_menu"] = "MENU_LEVEL"
	animation_player.play_backwards("blur")
	active = false
	
func _on_restart_button_pressed() -> void:
	if get_tree().paused:
		GameManager.reset_inits()
		resume()
		get_tree().reload_current_scene()
	
func _on_quit_button_pressed() -> void:
	if get_tree().paused:
		get_tree().quit()
	

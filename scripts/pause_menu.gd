extends Node2D

@onready var v_box_container: VBoxContainer = $PanelContainer/VBoxContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var active = false
var transition_time = 0.3
var selected_item: int = 0

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
	animation_player.play("blur")
	
func testEsc():
	
	if Input.is_action_just_pressed("Pause") and !get_tree().paused and !active:
		pause()
	elif Input.is_action_just_pressed("Pause") and get_tree().paused and active:
		resume()
		
func _process(delta: float) -> void:
	testEsc()
	
	if(active):
		if Input.is_action_just_pressed("pause_down"):
			selected_item = (selected_item + 1)%v_box_container.get_child_count()
		if Input.is_action_just_pressed("pause_up"):
			if selected_item == 0:
				selected_item = v_box_container.get_child_count() - 1
			else:
				selected_item -= 1
		if Input.is_action_just_pressed("Interact"):
			v_box_container.get_child(selected_item).emit_signal("pressed")
		update_highlighted_button()

	
	if (GameManager.menu_info["active_menu"] == "MENU_PAUSE") and !active:
		active = true
		animation_player.play("back_from_other_menu")
	elif (GameManager.menu_info["active_menu"] != "MENU_PAUSE") and active:
		active = false

func _on_resume_button_pressed() -> void:
	if get_tree().paused:
		resume()

func _on_level_button_pressed() -> void:
	GameManager.menu_info["active_menu"] = "MENU_LEVEL"
	active = false
	animation_player.play("level_menu_transition")
	
func _on_restart_button_pressed() -> void:
	if get_tree().paused:
		GameManager.reset_inits()
		GameManager.checkpoint_reached = false
		resume()
		get_tree().reload_current_scene()
	
func _on_quit_button_pressed() -> void:
	if get_tree().paused:
		get_tree().quit()
	

func update_highlighted_button() -> void:
	var v_box_children = v_box_container.get_children()
	for button in v_box_children:
		button.add_theme_color_override("font_color", "ffffff")
	v_box_children[selected_item].add_theme_color_override("font_color", "00ff00")
	

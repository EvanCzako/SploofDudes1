extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var active = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("RESET")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (GameManager.menu_info["active_menu"] == "MENU_LEVEL") and !active:
		print("SHOULD BE LEVEL MENU")
		active = true
		animation_player.play("blur")
	elif (GameManager.menu_info["active_menu"] != "MENU_LEVEL") and active:
		active = false


func _on_back_button_pressed() -> void:
	active = false
	animation_player.play_backwards("blur")
	GameManager.menu_info["active_menu"] = "MENU_PAUSE"


func _on_map_1_button_pressed() -> void:
	GameManager.reset_inits()
	get_tree().paused = false
	GameManager.menu_info["active_menu"] = null
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")


func _on_map_2_button_pressed() -> void:
	GameManager.reset_inits()
	get_tree().paused = false
	GameManager.menu_info["active_menu"] = null
	get_tree().change_scene_to_file("res://scenes/level_2.tscn")

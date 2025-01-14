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
		animation_player.play_backwards("blur")
	pass

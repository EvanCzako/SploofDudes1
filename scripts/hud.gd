extends CanvasLayer
const HUD_HEART = preload("res://scenes/hud_heart.tscn")
var curr_hearts: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curr_hearts = GameManager.player_info_live["health"]
	render(curr_hearts)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManager.player_info_live["health"] != curr_hearts:
		curr_hearts = GameManager.player_info_live["health"]
		render(curr_hearts)

func render(hearts: float):
	for heart in get_children():
		heart.queue_free()
	var child_heart
	var x_pos
	var y_pos = 40
	for i in range(hearts):
		x_pos = 40*(i+1)
		child_heart = HUD_HEART.instantiate()
		add_child(child_heart)
		child_heart.position = Vector2(x_pos, y_pos)

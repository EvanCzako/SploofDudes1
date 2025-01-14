extends Node2D

var xDir = 1
var yDir = 0
var rotation_map_key = str(xDir) + "," + str(yDir)
@onready var muzzle_node: Area2D = $AnimatedSprite2D/MuzzleNode

const ARM_ROTATION_MAP = {
	"1,0": 0,
	"-1,0": 180,
	"0,1": 270,
	"0,-1": 90,
	"1,1": 315,
	"1,-1": 45,
	"-1,1": 225,
	"-1,-1": 135
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	yDir = 0
	xDir = 0
	if rotation_map_key in ARM_ROTATION_MAP:
		rotation_degrees = ARM_ROTATION_MAP.get(rotation_map_key)
	if Input.is_action_pressed("aim_down"):
		yDir = -1
	if Input.is_action_pressed("aim_up"):
		yDir = 1
	if Input.is_action_pressed("aim_left"):
		xDir = -1
	if Input.is_action_pressed("aim_right"):
		xDir = 1
	rotation_map_key = str(xDir) + "," + str(yDir)

func _on_muzzle_node_body_entered(body: Node2D) -> void:
	GameManager.player_info_live["muzzle_blocked"] = true

func _on_muzzle_node_body_exited(body: Node2D) -> void:
	GameManager.player_info_live["muzzle_blocked"] = false

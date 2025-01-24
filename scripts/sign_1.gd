extends Area2D

@export var sign_text: String = "Default text!"
var openable: bool = false
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var rich_text_label: RichTextLabel = $CanvasLayer/RichTextLabel
@onready var hint_label: RichTextLabel = $HintLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas_layer.visible = false
	rich_text_label.text = sign_text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		if openable and !canvas_layer.visible:
			canvas_layer.visible = true
		else:
			canvas_layer.visible = false

func _on_hint_area_body_entered(body: Node2D) -> void:
	if body.name == "BoofBro":
		hint_label.visible = true
		openable = true


func _on_hint_area_body_exited(body: Node2D) -> void:
	if body.name == "BoofBro":
		hint_label.visible = false
		openable = false

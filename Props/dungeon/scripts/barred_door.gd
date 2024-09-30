class_name BarredDoor extends Node2D

var is_open: bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func open_door() -> void:
	animation_player.play("open_door")
	
func close_door() -> void:
	animation_player.play("close_door")

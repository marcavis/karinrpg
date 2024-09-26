class_name MoveComponent
extends Node

@export var actor: Node2D
@export var input_vector: Vector2 = Vector2.ZERO

func _input(event: InputEvent) -> void:
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

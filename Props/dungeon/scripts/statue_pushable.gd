class_name StatuePushable extends RigidBody2D

@export var push_speed: float = 30.0
var push_direction: Vector2 = Vector2.ZERO:
	set = _set_push

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	linear_velocity = push_direction * push_speed 
	pass

func _set_push(value: Vector2) -> void:
	push_direction = value
	if push_direction == Vector2.ZERO:
		audio.stop
	else:
		audio.play
	

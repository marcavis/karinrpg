class_name Pushable extends Node2D

@export var push_speed: float = 30.0
var push_direction: Vector2 = Vector2.ZERO:
	set = _set_push
var pusher: Player = null

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta: float) -> void:
	##velocity = push_direction * push_speed
	#if pusher:
		#velocity = pusher.velocity.normalized() * push_speed
		#move_and_slide()
	#pass

func _set_push(value: Vector2) -> void:
	push_direction = value
	if push_direction == Vector2.ZERO:
		audio.stop()
	else:
		audio.play()
	

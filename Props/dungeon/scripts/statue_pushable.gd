class_name StatuePushable extends CharacterBody2D

@export var push_speed: float = 30.0
var push_direction: Vector2 = Vector2.ZERO:
	set = _set_push
var pusher: Player = null
var inertia_over: bool = false

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !pusher:
		inertia_over = false
	if pusher and inertia_over:
		velocity = pusher.velocity.normalized() * push_speed
		move_and_slide()

func _set_push(value: Vector2) -> void:
	push_direction = value
	delayed_push()
	if push_direction == Vector2.ZERO:
		audio.stop()
	else:
		audio.play()

func delayed_push() -> void:
	await get_tree().create_timer(0.2).timeout
	inertia_over = true

extends CharacterBody2D

const ACCELERATION = 600
const MAX_SPEED = 90
const FRICTION = 900
var speed = Vector2.ZERO

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationState.travel("Run")
		#speed = input_vector
		#animationPlayer.play("RunRight")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		#animationPlayer.play("IdleRight")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		#speed = Vector2.ZERO
		
	#if Input.is_action_pressed("ui_right"):
		#speed.x = 10
	#elif Input.is_action_pressed("ui_left"):
		#speed.x = -10
	#else:
		#speed.x = 0
	# Add the gravity.
	#if not is_on_floor():
	#	velocity.y += gravity * delta

	#velocity.x = 100
	move_and_slide()
	

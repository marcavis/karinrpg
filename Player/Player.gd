extends CharacterBody2D

@export var ACCELERATION = 600
@export var MAX_SPEED = 90
@export var ROLL_SPEED = 120
@export var FRICTION = 900

enum {
	MOVE,
	ROLL,
	ATTACK
}

var speed = Vector2.ZERO
var state = MOVE
var roll_vector = Vector2.DOWN
var stats = PlayerStats

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var swordHitbox = %SwordHitbox
@onready var hurtbox: Area2D = $Hurtbox
@onready var blink_animation_player: AnimationPlayer = $BlinkAnimationPlayer


#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	randomize()
	#stats.connect("no_health", Callable(self, "queue_free"))
	stats.no_health.connect(queue_free)
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	
	
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		#animationTree.set("parameters/Attack/blend_position", input_vector)
		#animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		#speed = input_vector
		#animationPlayer.play("RunRight")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		#animationPlayer.play("IdleRight")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		#speed = Vector2.ZERO
		
	move_and_slide()
	#if Input.is_action_just_pressed("attack"):
		#state = ATTACK
	#if Input.is_action_just_pressed("roll"):
		#state = ROLL
	
func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move_and_slide()

func attack_state(delta):
	velocity = velocity/2
	animationState.travel("Attack")

func roll_animation_finished():
	velocity = Vector2.ZERO
	state = MOVE

func attack_animation_finished():
	state = MOVE
	
func _on_hurtbox_area_entered(area: Area2D) -> void:
	hurtbox.start_invincibility(0.5)
	stats.health -= 1


func _on_hurtbox_invincibility_started() -> void:
	blink_animation_player.play("start")


func _on_hurtbox_invincibility_ended() -> void:
	blink_animation_player.play("stop")

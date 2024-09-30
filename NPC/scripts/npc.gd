@tool
@icon ("res://NPC/icons/npc.svg")
class_name NPC extends CharacterBody2D

@export var ACCELERATION = 600
@export var MAX_SPEED = 45
@export var FRICTION = 900
@export var wander_range: int = 40

@export var npc_resource: NPCResource:
	set = _set_npc_resource

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var blink_animation_player: AnimationPlayer = $BlinkAnimationPlayer
@onready var timer: Timer = $Timer

var start_position: Vector2

enum {
	MOVE,
	IDLE,
	NEW_DIRECTION
}

var speed = Vector2.ZERO
var state = IDLE
var movement_vector = Vector2.DOWN
#direction = pick_random_state([IDLE, WANDER])
#NPC, doesn't need stats, probably
#@onready var stats: Node = $Stats

func choose(options: Array):
	options.shuffle()
	return options.front()

func _ready():
	randomize()
	setup_npc()
	start_position = global_position
	#stats.connect("no_health", Callable(self, "queue_free"))
	#stats.no_health.connect(queue_free)

func setup_npc() -> void:
	if npc_resource:
		if sprite_2d:
			sprite_2d.texture = npc_resource.sprite

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		IDLE:
			idle_state(delta)
		NEW_DIRECTION:
			pick_new_direction()
			
	
func move_state(delta):
	animationState.travel("Run")
	animationTree.set("parameters/Run/blend_position", movement_vector)
	velocity = velocity.move_toward(movement_vector * MAX_SPEED, ACCELERATION * delta)
	move_and_slide()

func idle_state(delta):
	animationState.travel("Idle")
	animationTree.set("parameters/Idle/blend_position", movement_vector)
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()

func pick_new_direction():
	var directions: Array[Vector2] = [Vector2.RIGHT,Vector2.RIGHT,Vector2.RIGHT,Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP]
	movement_vector = choose(directions)
	var deltax = global_position.x - start_position.x
	var deltay = global_position.y - start_position.y
	#if we are too far in the X or Y axis, and the movement vector we picked
	#would push us further in the same direction, reverse the movement vector
	if deltax * movement_vector.x > wander_range || deltay * movement_vector.y > wander_range:
		movement_vector = -movement_vector
	state = MOVE

func _on_timer_timeout() -> void:
	timer.wait_time = choose([0.5, 1.0, 1.5])
	state = choose([IDLE, NEW_DIRECTION])
	
func _on_push_avoidance_zone_bumped_with_something() -> void:
	#TODO: DO I really need this?
	state = IDLE
	pass # Replace with function body.

func _set_npc_resource(_npc: NPCResource) -> void:
	npc_resource = _npc
	setup_npc()

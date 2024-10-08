@tool
@icon ("res://NPC/icons/npc.svg")
class_name NPC extends CharacterBody2D

@export var ACCELERATION = 600
@export var MAX_SPEED = 45
@export var FRICTION = 900
@export var wander_range: int = 40
@export var push_speed: float = 30.0
@export var npc_resource: NPCResource:
	set = _set_npc_resource
var push_direction: Vector2 = Vector2.ZERO:
	set = _set_push
var pusher: Player = null
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var blink_animation_player: AnimationPlayer = $BlinkAnimationPlayer
@onready var timer: Timer = $Timer
@onready var bump_avoidance_zone: Area2D = $PushAvoiderPivot/BumpAvoidanceZone


var dialog_interaction: DialogInteraction = null
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
	if Engine.is_editor_hint():
		return
	gather_dialog_items()
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
	velocity = velocity.move_toward(push_direction * push_speed + Vector2.ZERO, FRICTION * delta)
	move_and_slide()

func pick_new_direction():
	var directions: Array[Vector2] = [Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP]
	#if we're facing the player and it's nearby, let's
	#pick a different direction than current
	if bump_avoidance_zone.player_is_nearby():
		directions.erase(movement_vector)
	movement_vector = choose(directions)
	var deltax = global_position.x - start_position.x
	var deltay = global_position.y - start_position.y
	#if we are too far in the X or Y axis, and the movement vector we picked
	#would push us further in the same direction, reverse the movement vector
	if deltax * movement_vector.x > wander_range || \
		deltay * movement_vector.y > wander_range:
		movement_vector = -movement_vector
	state = MOVE

func _on_timer_timeout() -> void:
	timer.wait_time = choose([0.5, 1.0, 1.5])
	state = choose([IDLE, NEW_DIRECTION])

#prevent from i
func _reset_timer_for_interaction() -> void:
	timer.wait_time = 1.5

func _set_npc_resource(_npc: NPCResource) -> void:
	npc_resource = _npc
	setup_npc()
	
func _set_push(value: Vector2) -> void:
	push_direction = value


func _on_bump_avoidance_zone_bumped_with_something() -> void:
	state = IDLE

func start_interaction(_player: Player) -> void:
	state = IDLE
	_reset_timer_for_interaction()
	movement_vector = -_player.direction
	await get_tree().create_timer(0.1).timeout
	DialogSystem.show_dialog_ui(dialog_interaction.dialog_items)

func gather_dialog_items() -> void:
	for c in get_children():
		if c is DialogInteraction:
			dialog_interaction = c
			c.player_interacted.connect(_on_player_interacted)
			c.finished.connect(_on_interaction_finished)
			
func _on_player_interacted() -> void:
	state = IDLE
	
func _on_interaction_finished() -> void:
	pass

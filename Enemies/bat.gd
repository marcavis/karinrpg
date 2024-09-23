extends CharacterBody2D

@export var ACCELERATION = 300
@export var MAX_SPEED = 50
@export var FRICTION = 200

const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")
@onready var player_detection_zone: Area2D = $PlayerDetectionZone
var velocityVector: Vector2 = Vector2.ZERO
var KNOCKBACK_SPEED = 120
@onready var stats: Node = $Stats
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Area2D = $Hurtbox
@onready var soft_collision: Area2D = $SoftCollision
@onready var wander_controller: Node2D = $WanderController
@onready var blink_animation_player: AnimationPlayer = $BlinkAnimationPlayer

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = CHASE

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, 200*delta)
			seek_player()
			if wander_controller.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wander_controller.set_wander_timer(randf_range(1, 3))
			
		WANDER:
			seek_player()
			if wander_controller.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wander_controller.set_wander_timer(randf_range(1, 3))
			var direction = global_position.direction_to(wander_controller.target_position)
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			
		CHASE:
			var player = player_detection_zone.player
			if player != null:
				#var direction = (player.global_position - global_position).normalized()
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0
	
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 400
	move_and_slide()			

func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE

func pick_random_state(state_list: Array):
	state_list.shuffle()
	return state_list.pop_front()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage
	velocity = area.knockback_vector * 120
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)
	#Following: 360 degree knockback
	#var direction = ( position - area.owner.position ).normalized()
	#velocity = direction * KNOCKBACK_SPEED

func _on_stats_no_health() -> void:
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position


func _on_hurtbox_invincibility_ended() -> void:
	blink_animation_player.play("stop")


func _on_hurtbox_invincibility_started() -> void:
	blink_animation_player.play("start")

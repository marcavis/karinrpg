extends Area2D

@export var show_hit: bool = true
@onready var timer: Timer = $Timer


signal invincibility_started
signal invincibility_ended

const HitEffect = preload("res://Effects/hit_effect.tscn")
var invincible: bool = false:
	set(state):
		invincible = state
		if invincible:
			emit_signal("invincibility_started")
		else:
			emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var effect = HitEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position - Vector2(0, 8)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if show_hit:
		var effect = HitEffect.instantiate()
		var main = get_tree().current_scene
		main.add_child(effect)
		effect.global_position = global_position - Vector2(0, 8)

func _on_timer_timeout() -> void:
	self.invincible = false


func _on_invincibility_started() -> void:
	set_deferred("monitoring", false)


func _on_invincibility_ended() -> void:
	monitoring = true

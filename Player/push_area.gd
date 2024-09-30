extends Area2D

@onready var player: Player = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect( _on_body_entered )
	body_exited.connect( _on_body_exited )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(b: Node2D) -> void:
	if b is StatuePushable:
		#let's only push in cardinal directions
		var normalized: Vector2 = player.velocity.normalized()
		print(normalized)
		if abs(normalized.x + normalized.y) == 1.0:
			b.push_direction = normalized
		
		#b.push_direction = player.

func _on_body_exited(b: Node2D) -> void:
	if b is StatuePushable:
		b.push_direction = Vector2.ZERO

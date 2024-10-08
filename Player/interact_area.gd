extends Area2D

@onready var player: Player = $"../../.."
var targets: Array[Node2D]

func _ready() -> void:
	body_entered.connect( _on_body_entered )
	body_exited.connect( _on_body_exited )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(b: Node2D) -> void:
	if b.has_node("DialogInteraction"):
		targets.append(b)

func _on_body_exited(b: Node2D) -> void:
	targets.erase(b)
	

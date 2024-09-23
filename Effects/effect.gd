extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("animation_finished", Callable(self, "_on_animation_finished"))
	play("animate")

func _on_animation_finished() -> void:
	queue_free()

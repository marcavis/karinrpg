extends Camera2D

@onready var bottom_right: Marker2D = $Limits/BottomRight
@onready var top_left: Marker2D = $Limits/TopLeft

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	limit_top = top_left.position.y
	limit_left = top_left.position.x
	limit_bottom = bottom_right.position.y
	limit_right = bottom_right.position.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

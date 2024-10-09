extends Node

signal level_load_started
signal level_loaded
signal tilemap_bounds_changed (bounds: Array[Vector2])

var current_tilemap_bounds : Array[Vector2]
var target_transition_area : String
var position_offset : Vector2

func change_tilemap_bounds(bounds: Array[Vector2]):
	current_tilemap_bounds = bounds
	tilemap_bounds_changed.emit(bounds)

#func 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Node

signal level_load_started
signal level_loaded
signal tilemap_bounds_changed (bounds: Array[Vector2])

var current_tilemap_bounds : Array[Vector2]
var target_transition : String
var position_offset : Vector2

func change_tilemap_bounds(bounds: Array[Vector2]):
	current_tilemap_bounds = bounds
	tilemap_bounds_changed.emit(bounds)

#func 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	level_loaded.emit()

	
func load_new_level(
	level_scene: String,
	_target_transition: String,
	_position_offset: Vector2
) -> void:
	get_tree().paused = true
	target_transition = _target_transition
	position_offset = _position_offset
	
	await get_tree().process_frame
	level_load_started.emit()
	await get_tree().process_frame
	get_tree().change_scene_to_file(level_scene)
	await get_tree().process_frame
	get_tree().paused = false
	await get_tree().process_frame
	level_loaded.emit()

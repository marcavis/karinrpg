@tool
class_name LevelTransition extends Area2D

enum SIDE { LEFT, RIGHT, BOTTOM, TOP}
@export_file("*.tscn") var level 
@export var target_transition_area: String = "LevelTransition"

@export_category("Collision Area Settings")

@export_range(1, 12, 2, "or_greater") var size: int = 3:
	set(_value):
		size = _value
		_update_area()
		
@export var side: SIDE = SIDE.LEFT
@export var snap_to_grid: bool = false:
	set(_value):
		_snap_to_grid()
		
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(self, self.monitoring)
	_update_area()
	if Engine.is_editor_hint():
		return
	monitoring = false
	_place_player()
	
	await LevelManager.level_loaded
	
	monitoring = true
	body_entered.connect(_player_entered)

func _player_entered(_player: Node2D) -> void:
	print("Owo")
	LevelManager.load_new_level(level, target_transition_area, get_offset())
	pass
	
func _place_player() -> void:
	print("place")
	print(name, "ehh", LevelManager.target_transition)
	if name != LevelManager.target_transition:
		return
	PlayerManager.set_player_position(global_position + LevelManager.position_offset)
	

func _update_area() -> void:
	var new_rect : Vector2 = Vector2(16, 16)
	var new_position : Vector2 = Vector2.ZERO
	
	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D")
		
	collision_shape.shape.size = new_rect * size
	collision_shape.position = new_position

func _snap_to_grid() -> void:
	position.x = round(position.x/16) * 16
	position.y = round(position.y/16) * 16

func get_offset() -> Vector2:
	var offset: Vector2 = Vector2.ZERO
	var player_pos: Vector2 = PlayerManager.player.global_position
	match side:
		SIDE.LEFT:
			offset = Vector2(-32, 0)
		SIDE.RIGHT:
			offset = Vector2(32, 0)
		SIDE.BOTTOM:
			offset = Vector2(0, 32)
		SIDE.TOP:
			offset = Vector2(0, -32)
	return offset 
	

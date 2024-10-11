extends Node

const PLAYER_SCENE = preload("res://Player/player.tscn")
var player: Player
var player_spawned: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.1).timeout
	player_spawned = true
	
	#player.add_child(Camera2D.new())


func add_player_instance() -> void:
	player = PLAYER_SCENE.instantiate()
	add_child(player)

func set_player_position(_new_pos: Vector2) -> void:
	print(player.global_position)
	player.global_position = _new_pos
	print(player.global_position)
	
func set_as_parent(thing: Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	thing.add_child(player)

func unparent_player(thing: Node2D) -> void:
	thing.remove_child(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

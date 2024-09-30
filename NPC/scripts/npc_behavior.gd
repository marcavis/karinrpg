@icon ("res://NPC/icons/npc_behavior.svg")
class_name NPCBehavior extends Node2D

var npc : NPC

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var p = get_parent()
	if p is NPC:
		npc = p
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

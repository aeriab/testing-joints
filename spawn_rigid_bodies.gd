extends Node2D

@export var stone_scene: PackedScene

var stone: Stone

func _process(delta: float) -> void:
	if Input.is_action_pressed("spawn"):
		stone = stone_scene.instantiate() as Stone
		stone.global_position = get_global_mouse_position()
		get_parent().add_child(stone)

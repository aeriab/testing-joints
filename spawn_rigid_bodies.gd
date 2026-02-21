extends Node2D

@export var ball_scene: PackedScene

var ball: Ball

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spawn"):
		ball = ball_scene.instantiate() as Ball
		ball.global_position = get_global_mouse_position()
		get_parent().add_child(ball)

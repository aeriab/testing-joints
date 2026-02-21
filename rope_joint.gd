extends Node2D

@export var body1: RigidBody2D
@export var body2: RigidBody2D

@export var max_distance: float


func _physics_process(delta: float) -> void:
	var diff := body2.global_position - body1.global_position
	var dist := diff.length()
	if dist > max_distance:
		var dir := diff / dist
		var mid := (body1.global_position + body2.global_position) / 2.0
		body1.global_position = mid - dir * max_distance / 2.0
		body2.global_position = mid + dir * max_distance / 2.0

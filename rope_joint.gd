class_name RopeJoint
extends Node2D

@export var body1: RigidBody2D
@export var body2: RigidBody2D

@export var pull_back_distance: float
@export var disconnect_distance: float


func _physics_process(delta: float) -> void:
	var diff := body2.global_position - body1.global_position
	var dist := diff.length()
	if dist > disconnect_distance:
		body1.connected_bodies.erase(body2)
		queue_free()
	elif dist > pull_back_distance:
		var dir := diff / dist
		var mid := (body1.global_position + body2.global_position) / 2.0
		body1.global_position = mid - dir * pull_back_distance / 2.0
		body2.global_position = mid + dir * pull_back_distance / 2.0
	
	queue_redraw()



func _draw() -> void:
	if body1 and body2:
		var dir: Vector2 = Vector2 (	body2.global_position.x - body1.global_position.x,
										body2.global_position.y - body1.global_position.y).normalized()
		var local_start := to_local(body1.global_position)
		draw_line(local_start, local_start + dir * pull_back_distance, Color(1, 1, 0, 0.4), 2.0)

extends DampedSpringJoint2D

@export var stiff_float: float

var body_a: RigidBody2D
var body_b: RigidBody2D

func _ready() -> void:
	stiffness = stiff_float
	body_a = get_node(node_a)
	body_b = get_node(node_b)

func setup_bodies() -> void:
	body_a = get_node(node_a)
	body_b = get_node(node_b)

func _physics_process(_delta: float) -> void:
	if (body_a && body_b):
		#print("making it here!")
		var midpoint := (body_a.global_position + body_b.global_position) / 2.0
		var dir := body_a.global_position.direction_to(body_b.global_position)
		
		# Place the joint at body_a's end (half the length back from midpoint)
		global_position = midpoint - dir * (length / 2.0)
		global_rotation = dir.angle() - (PI/2)

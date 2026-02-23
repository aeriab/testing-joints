class_name Stone
extends RigidBody2D

@export var mass_multiplier: float = 1.0
@export var aero_torque_strength: float = 5.0

func _ready() -> void:
	mass = mass_multiplier

func _physics_process(_delta: float) -> void:
	if not freeze:
		apply_central_force(stone_acceleration(global_position))
		
		
		# Simulated aerodynamic restoring torque
		if linear_velocity.length_squared() > 1.0:
			var angle_diff = wrapf(linear_velocity.angle() - rotation, -PI, PI)
			apply_torque(angle_diff * aero_torque_strength * linear_velocity.length())

@export var planet_radius: float = 500.0  # approximate radius of your stone planet

func stone_acceleration(pos: Vector2) -> Vector2:
	var dist := pos.length()
	if dist < 1.0:
		return Vector2.ZERO
	var gravity_factor := clampf(dist / planet_radius, 0.0, 1.0)
	return pos.direction_to(Vector2.ZERO) * Global.gravity * 100 * mass * gravity_factor


@export var rope_joint_scene: PackedScene
@export var separation: float = 0
@export var connection_buffer: float = 150.0

@export_group("Spring", "_spring")
@export var spring_stiffness: float = 500.0
@export var spring_damping: float = 5.0

var radius: float = 50

var connected_bodies: Array[RigidBody2D] = []

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("connectable"):
		if get_instance_id() < body.get_instance_id():
			var joint_distance: float = radius + body.radius + separation
			if (body not in connected_bodies) and (joint_distance - connection_buffer < (body.global_position - global_position).length()):
				connected_bodies.append(body)
				
				var rope_joint = rope_joint_scene.instantiate() as RopeJoint
				get_tree().current_scene.add_child(rope_joint)
				rope_joint.body1 = self
				rope_joint.body2 = body
				rope_joint.pull_back_distance = joint_distance
				rope_joint.disconnect_distance = joint_distance + 5.0
				rope_joint.spring_stiffness = spring_stiffness
				rope_joint.spring_damping = spring_damping

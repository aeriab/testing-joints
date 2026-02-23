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

func stone_acceleration(pos: Vector2) -> Vector2:
	return pos.direction_to(Vector2.ZERO) * Global.gravity * 100 * mass


@export var rope_joint_scene: PackedScene
@export var spring_joint_scene: PackedScene
@export var separation: float = 0
var radius: float = 50

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("connectable"):
		if get_instance_id() < body.get_instance_id():
			var joint_distance: float = radius + body.radius + separation
			print("joint distance: " + str(joint_distance))

			# Rope joint
			var rope_joint = rope_joint_scene.instantiate() as RopeJoint
			get_tree().current_scene.add_child(rope_joint)
			rope_joint.body1 = self
			rope_joint.body2 = body
			rope_joint.max_distance = joint_distance
			
			

			# Spring joint
			#var spring_joint = spring_joint_scene.instantiate() as DampedSpringJoint2D
			#get_tree().current_scene.add_child(spring_joint)
			#spring_joint.global_position = global_position
			#spring_joint.node_a = spring_joint.get_path_to(self)
			#spring_joint.node_b = spring_joint.get_path_to(body)
			#spring_joint.length = joint_distance
			#spring_joint.rest_length = joint_distance
			#spring_joint.setup_bodies()

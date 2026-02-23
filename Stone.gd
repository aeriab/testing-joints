class_name Stone
extends RigidBody2D

@export_group("Stone Properties")
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

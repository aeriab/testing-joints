class_name Ball
extends RigidBody2D

@export var max_speed: float = 800.0
@export var max_angular_speed: float = 800.0


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# 1. Collect all forces: Gravity + any apply_force() calls from other scripts
	# F = ma -> a = F/m. We add (Acceleration * delta) to velocity.
	var total_force_accel = (state.total_gravity + (state.get_constant_force() / mass))
	state.linear_velocity += total_force_accel * state.step
	
	# 2. Manually apply Damping (Drag)
	state.linear_velocity *= clamp(1.0 - state.step * linear_damp, 0, 1)
	state.angular_velocity *= clamp(1.0 - state.step * angular_damp, 0, 1)

	# 3. THE ABSOLUTE CLAMP
	# By doing this LAST and without calling state.integrate_forces(), 
	# nothing can override this value before the physics step finishes.
	state.linear_velocity = state.linear_velocity.limit_length(max_speed)
	state.angular_velocity = clamp(state.angular_velocity, -max_angular_speed, max_angular_speed)
	
	# 4. Clear the forces so they don't compound infinitely
	state.set_constant_force(Vector2.ZERO)
	state.set_constant_torque(0.0)

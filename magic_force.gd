extends Node2D

## Debug force tool - applies outward radial force from mouse position

@export var force_strength: float = 500.0
@export var force_radius: float = 200.0
@export var show_debug: bool = true

func _process(delta: float) -> void:
	if show_debug:
		queue_redraw()

func _physics_process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		apply_radial_force(get_global_mouse_position())

func apply_radial_force(origin: Vector2) -> void:
	# Grab every RigidBody2D in the scene
	var bodies := get_tree().get_nodes_in_group("physics_bodies")
	
	for node in bodies:
		print("have some bodies")
		if node is RigidBody2D:
			var body: RigidBody2D = node
			var direction: Vector2 = body.global_position - origin
			var distance: float = direction.length()
			
			if distance < force_radius and distance > 0.01:
				# Linear falloff — full strength at center, zero at radius edge
				var strength := force_strength * (1.0 - distance / force_radius)
				body.apply_force(direction.normalized() * strength)

func _draw() -> void:
	if not show_debug:
		return
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var local_mouse := to_local(get_global_mouse_position())
		# Outer radius ring
		draw_arc(local_mouse, force_radius, 0, TAU, 64, Color(1, 0.3, 0.3, 0.4), 2.0)
		# Inner crosshair
		draw_circle(local_mouse, 4.0, Color(1, 0.3, 0.3, 0.8))

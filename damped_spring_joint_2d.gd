extends DampedSpringJoint2D

@export var stiff_float: float
func _ready() -> void:
	stiffness = stiff_float

extends CollisionShape2D

func _ready() -> void:
	shape.custom_solver_bias = Global.custom_solver_bias

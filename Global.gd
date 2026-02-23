extends Node

var planet_radius: float = 1.0
var planet_radius_update_interval: float = 0.5
var _radius_timer: float = 0.0

## What percentile of stones defines the "surface" (ignores outliers)
@export var radius_percentile: float = 0.8

func _physics_process(delta: float) -> void:
	_radius_timer += delta
	if _radius_timer >= planet_radius_update_interval:
		_radius_timer = 0.0
		_update_planet_radius()

func _update_planet_radius() -> void:
	var stones := get_tree().get_nodes_in_group("stone")
	if stones.is_empty():
		planet_radius = 1.0
		return
	
	var distances: Array[float] = []
	for stone in stones:
		distances.append(stone.global_position.length())
	distances.sort()
	
	# Use the nth percentile stone as the planet surface
	var index := int(distances.size() * radius_percentile) 
	index = clampi(index, 0, distances.size() - 1)
	planet_radius = maxf(distances[index], 1.0)
	print("planet radius: " + str(planet_radius))



var custom_solver_bias: float = 1.2

var gravity: float = 9.8

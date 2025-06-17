class_name EnemyState
extends State

@onready var enemy: CharacterBody3D = get_parent().enemy
@export var DETECT_RAY: RayCast3D

func get_detect_ray_len() -> float:
		return (DETECT_RAY.get_collision_point() - enemy.global_position).length()

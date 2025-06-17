class_name EnemyState
extends State

@onready var enemy: CharacterBody3D = get_parent().enemy
@export var DETECT_RAY: RayCast3D

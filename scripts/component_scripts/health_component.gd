class_name HealthComponent
extends Node

signal damage_taken(stun_time: float)

@export var STUN_TIME : int = 0
@export var MAX_HEALTH : int = 10
@export var current_health : int = 10


func _ready() -> void:
	damage_taken.connect(Callable(get_parent(), "_on_damage_taken"))


func heal(amount: int) -> void:
	current_health += amount
	if current_health > MAX_HEALTH: current_health = MAX_HEALTH
	if get_parent() is Player:
		Global.gui_manager.set_health(current_health)


func take_damage(amount: int) -> void:
	current_health -= amount
	
	if current_health <= 0:
		current_health = 0
	var is_dead := false if current_health > 0 else true
	damage_taken.emit(STUN_TIME, is_dead)

	if get_parent() is Player:
		Global.gui_manager.set_health(current_health)

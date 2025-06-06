class_name HealthComponent
extends Node

@warning_ignore("unused_signal")
signal died
signal stunned(stun_time: int)
@warning_ignore("unused_signal")
signal health_changed()

@export var STUN_TIME : int = 0
@export var MAX_HEALTH : int = 10
@export var current_health : int = 10


func _ready() -> void:
	died.connect(Callable(get_parent(), "_on_died"))


func heal(amount: int) -> void:
	current_health += amount
	if current_health > MAX_HEALTH: current_health = MAX_HEALTH
	if get_parent() is Player:
		Global.gui_manager.set_health(current_health)


func take_damage(amount: int) -> void:
	current_health -= amount
	
	if STUN_TIME > 0:
		stunned.emit(STUN_TIME)
		
	if current_health <= 0:
		died.emit()
		current_health = 0

	if get_parent() is Player:
		Global.gui_manager.set_health(current_health)

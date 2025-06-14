class_name HitboxComponent
extends Area3D

@export var health_component : HealthComponent

func take_damage(amount: int) -> void:
	if health_component:
		health_component.take_damage(amount)
		#if get_parent() is CharacterBody3D:
			#get_parent().velocity += knockback_force
	

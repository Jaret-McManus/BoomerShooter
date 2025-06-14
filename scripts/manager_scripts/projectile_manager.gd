class_name ProjectileManager
extends Node3D

func _ready() -> void:
	Global.projectile_manager = self

func add_projectile(proj: Projectile) -> void:
	self.add_child(proj)

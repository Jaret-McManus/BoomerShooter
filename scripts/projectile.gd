class_name Projectile
extends Node3D

@export var collision_ray: RayCast3D

var speed: float
var damage: float

func initialize(param_speed: float, param_lifetime: float, param_damage: float, param_pos: Vector3, param_basis: Basis) -> void:
	self.speed = param_speed
	self.damage = param_damage
	self.position = param_pos
	self.global_basis = param_basis
	
	await get_tree().create_timer(param_lifetime).timeout
	queue_free()


func _process(delta: float) -> void:
	self.position += self.basis.z * -speed * delta
	if collision_ray.is_colliding():
		var collider: Object = collision_ray.get_collider()
		
		if collider is HitboxComponent:
			collider.take_damage(damage)
		
		queue_free()

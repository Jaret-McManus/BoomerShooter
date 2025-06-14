class_name Projectile
extends Node3D

@export var collision_ray: RayCast3D

var speed: float
var damage: float
var init_position: Vector3
var falloff: Callable

func initialize(param_speed: float, param_lifetime: float, param_damage: float, param_pos: Vector3, param_basis: Basis, param_falloff: Callable = Callable() ) -> void:
	self.speed = param_speed
	self.damage = param_damage
	self.position = param_pos
	self.init_position = param_pos
	self.global_basis = param_basis
	
	self.falloff = param_falloff
	await get_tree().create_timer(param_lifetime).timeout
	queue_free()


func _process(delta: float) -> void:
	self.position += self.basis.z * -speed * delta
	if collision_ray.is_colliding():
		var collider: Object = collision_ray.get_collider()
		
		if collider is HitboxComponent:
			var damage_dealt: int
			if falloff.is_null():
				damage_dealt = floori(damage)
			else:
				var distance: float = (position - init_position).length()
				damage_dealt = floori(falloff.call(distance, damage))
			
			if damage_dealt > 0:
				collider.take_damage(damage_dealt)
		
		queue_free()

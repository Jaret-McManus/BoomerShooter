class_name Weapon
extends Node3D

enum WeaponTypes {MELEE, PROJECTILE}

@export var weapon_type : WeaponTypes
@export var ANIMATION_PLAYER : AnimationPlayer
@export var AREA : Area3D # this can be left empty for a projectile weapon
@export var attack_damage := 1
@export var knockback_force := 0
@export var stun_time := 0
@export var attack_distance := 0 # set this higher for projectile weapons
@export var projectile_scene : PackedScene # there's no projectile scene, but maybe it can be an Area3D node
@export var COLLISION_RAY: RayCast3D # used rn for melee

var enemy_targets: Array[Variant] = []


func _ready() -> void:
	#if weapon_type == WeaponTypes.MELEE:
		#AREA.connect("area_entered", _on_area_entered)
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"attack"):
		attack()


func attack() -> void:
	if not ANIMATION_PLAYER.is_playing():
		ANIMATION_PLAYER.play("attack")
	
	#if weapon_type != WeaponTypes.PROJECTILE: return
	#var new_projectile : Area3D = projectile_scene.instantiate()


func damage_targets() -> void:
	var is_hitbox: Callable = func(t: Area3D) -> bool:
		return t is HitboxComponent and not t.get_parent() is Player
		
	var overlapping_areas: Array[Area3D] = AREA.get_overlapping_areas()
	var hitboxes := overlapping_areas.filter(is_hitbox) # filter to only get Hitboxes
	var targets := hitboxes.filter(collision_check)
	
	for target: HitboxComponent in targets:
		target.take_damage(attack_damage)
		target.get_parent().position.y += 0.5


func collision_check(target: HitboxComponent) -> bool:
	#COLLISION_RAY.enabled = trues
	var target_origin: Vector3 = target.global_transform.origin
	COLLISION_RAY.target_position = COLLISION_RAY.to_local(target_origin)
	
	if COLLISION_RAY.is_colliding():
		var collider : Node3D = COLLISION_RAY.get_collider()
		#COLLISION_RAY.enabled = false
		if collider is HitboxComponent:
			return true
		else:
			return false
	
	return false


func enable_collision_ray() -> void:
	COLLISION_RAY.enabled = true


func disable_collision_ray() -> void:
	COLLISION_RAY.enabled = false

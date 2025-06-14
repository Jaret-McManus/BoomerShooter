class_name Weapon
extends Node3D

enum WeaponTypes {MELEE, PROJECTILE}

@export var weapon_type : WeaponTypes
@export var ANIMATION_PLAYER : AnimationPlayer
@export var AREA : Area3D # this can be left empty for a projectile weapon
@export var COLLISION_RAY: RayCast3D # used rn for melee
@export var SPRITE: Sprite3D
@export var sound_component: SoundComponent

@export var attack_damage := 1
@export var knockback_force := 0
@export var stun_time := 0
@export var attack_distance := 0 # set this higher fr projectile weapons
@export var projectile_scene : PackedScene # there's no projectile scene, but maybe it can be an Area3D node

var enemy_targets: Array[Variant] = []

const SPRITES: Dictionary[String, CompressedTexture2D] = {
	"shovel": preload("uid://djj146xxbugdq"),
	"shotgun": preload("uid://rp4n2y4kf0ss"),
}

func _ready() -> void:
	SPRITE.texture = SPRITES["shotgun"]
	#SPRITE.texture = SPRITES["shovel"]


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"attack"):
		attack()


func attack() -> void:
	if ANIMATION_PLAYER.is_playing():
		return 
	
	var animation: StringName
	match SPRITE.texture:
		SPRITES["shotgun"]:
			animation = &"shotgun_fire"
		SPRITES["shovel"]:
			animation = &"shovel_swing"
	
	ANIMATION_PLAYER.play(animation)
	sound_component.play_sound(animation)


func damage_targets() -> void:
	var is_valid_hitbox: Callable = func(t: Object) -> bool:
		return t is HitboxComponent and \
			not t.get_parent() is Player and \
			not t is Player
			
	var overlapping_areas: Array[Area3D] = AREA.get_overlapping_areas()
	var hitboxes := overlapping_areas.filter(is_valid_hitbox) # filter to only get Hitboxes
	var targets := hitboxes.filter(collision_check)
	
	for target: HitboxComponent in targets:
		target.take_damage(attack_damage)
		target.get_parent().position.y += 0.5


func collision_check(target: HitboxComponent) -> bool:
	var target_origin: Vector3 = target.global_transform.origin
	COLLISION_RAY.target_position = COLLISION_RAY.to_local(target_origin)
	
	if COLLISION_RAY.is_colliding():
		var collider: Object = COLLISION_RAY.get_collider()
		Debug.update_debug(&"collider", collider)
		if collider is HitboxComponent:
			return true
		else:
			return false
			
	return false


func enable_collision_ray() -> void:
	COLLISION_RAY.enabled = true


func disable_collision_ray() -> void:
	COLLISION_RAY.enabled = false

func fire_shot() -> void:
	match SPRITE.texture:
		SPRITES["shotgun"]:
			fire_shotgun()


func fire_shotgun() -> void:
	const NUM_PELLETS: int = 12
	const SPEED: float = 90
	const LIFETIME: float = 1
	const DAMAGE: float = 5
	const SPREAD: float = deg_to_rad(4)
	
	var FALLOFF: Callable = func(dist: float, damage: int) -> float: 
		var falloff_start: float = 5
		var falloff_end: float = 25
		if dist < falloff_start: return damage
		
		return clamp(
			damage - (damage / (falloff_end - falloff_start)) * (dist - falloff_start), 
			0, 
			damage
		) 
	
	for i in NUM_PELLETS:
		var projectile: Projectile = projectile_scene.instantiate()
		Global.projectile_manager.add_projectile(projectile)
		
		# add spread in circle
		var offset_basis: Basis = Basis(global_basis)
		
		# get uniform random point in circle with polar coords  
		var r: float = SPREAD * sqrt(randf())
		var theta: float = randf() * 2 * PI
		
		# convert to cartesian
		var spread_x: float = r * cos(theta)
		var spread_y: float = r * sin(theta)
		
		offset_basis = offset_basis.rotated(global_basis.x, spread_x)
		offset_basis = offset_basis.rotated(global_basis.y, spread_y)
		
		
		projectile.initialize(
			SPEED, LIFETIME, DAMAGE, self.global_position, offset_basis, FALLOFF
		)	
	
		

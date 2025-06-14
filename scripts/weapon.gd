class_name Weapon
extends Node3D

enum WeaponTypes {MELEE, PROJECTILE}

@export var weapon_type : WeaponTypes
@export var projectile_scene : PackedScene
@export var ANIMATION_PLAYER : AnimationPlayer
@export var AREA : Area3D
@export var COLLISION_SHAPE : CollisionShape3D
@export var COLLISION_RAY: RayCast3D
@export var SPRITE: Sprite3D
@export var sound_component: SoundComponent

var attack_damage : int = 1
var knockback_force : Vector3 = Vector3(0.0, 0.0, 0.0)
var attack_range : float = 1.0 
#@export var stun_time := 0

var enemy_targets: Array[Variant] = []

const SPRITES: Dictionary[String, CompressedTexture2D] = {
	&"shovel": preload("uid://djj146xxbugdq"),
	&"shotgun": preload("uid://rp4n2y4kf0ss"),
}


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"attack"):
		attack()


func _ready() -> void:
	set_weapon(&"shovel")


func set_weapon(weapon_name : StringName) -> void:
	match weapon_name:
		&"shovel":
			weapon_type = WeaponTypes.MELEE
			SPRITE.texture = SPRITES[&"shovel"]
			COLLISION_SHAPE.shape.size = Vector3(1.0, 2.0, attack_range)
			COLLISION_SHAPE.position = Vector3(0.0, 0.0, -(attack_range / 2.0))
		&"shotgun":
			weapon_type = WeaponTypes.PROJECTILE
			SPRITE.texture = SPRITES["shotgun"]
			

func attack() -> void:
	if ANIMATION_PLAYER.is_playing(): return 
	if weapon_type == WeaponTypes.PROJECTILE: 
		# moved this from the animation player
		fire_shot()
	var animation: StringName
	match SPRITE.texture:
		SPRITES[&"shotgun"]:
			animation = &"shotgun_fire"
		SPRITES[&"shovel"]:
			animation = &"shovel_swing"
	
	ANIMATION_PLAYER.play(animation)
	sound_component.play_sound(animation)


func melee_attack() -> void:
	match SPRITE.texture:
		SPRITES[&"shovel"]: 
			attack_damage = 7
			knockback_force = Vector3(0.0, 5.0, 0.0)
	
	var is_valid_hitbox: Callable = func(t: Object) -> bool:
		return t is HitboxComponent and \
			not t.get_parent() is Player and \
			not t is Player
	
	var overlapping_areas: Array[Area3D] = AREA.get_overlapping_areas()
	var hitboxes := overlapping_areas.filter(is_valid_hitbox) # filter to only get Hitboxes
	var targets := hitboxes.filter(is_visible_hitbox)
	var distance_from_player := 20.0
	var target_to_hit : HitboxComponent
	
	#only attacks the closest target in attack range
	for target: HitboxComponent in targets:
		var last_target_distance := distance_from_player
		distance_from_player = (global_position - target.global_position).length()
		if distance_from_player < last_target_distance: target_to_hit = target
	
	if target_to_hit:
		target_to_hit.take_damage(attack_damage, knockback_force)

# returns true if the collision ray can hit the target
func is_visible_hitbox(target: HitboxComponent) -> bool:
	var target_origin: Vector3 = target.global_transform.origin
	COLLISION_RAY.target_position = COLLISION_RAY.to_local(target_origin)
	
	if COLLISION_RAY.is_colliding():
		var collider: Object = COLLISION_RAY.get_collider()
		if collider is HitboxComponent:
			return true
		else:
			return false
			
	return false


func fire_shot() -> void:
	match SPRITE.texture:
		SPRITES[&"shotgun"]:
			fire_shotgun()


func fire_shotgun() -> void:
	const NUM_PELLETS: int = 12
	const SPEED: float = 60
	const LIFETIME: float = 1
	const DAMAGE: float = 3
	const KNOCKBACK_FORCE: Vector3 = Vector3(0.0, 0.5, 0.0)
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
			SPEED, LIFETIME, 
			DAMAGE, KNOCKBACK_FORCE, 
			self.global_position, offset_basis, 
			FALLOFF
		)


func enable_collision_ray() -> void:
	COLLISION_RAY.enabled = true


func disable_collision_ray() -> void:
	COLLISION_RAY.enabled = false

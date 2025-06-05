extends MeshInstance3D

enum WeaponTypes {MELEE, PROJECTILE}

@export var weapon_type : WeaponTypes
@export var ANIMATION_PLAYER : AnimationPlayer
@export var AREA : Area3D # this can be left empty for a projectile weapon
@export var attack_damage := 1
@export var knockback_force := 0
@export var stun_time := 0
@export var attack_distance := 0 # set this higher for projectile weapons
@export var projectile_scene : PackedScene # there's no projectile scene, but maybe it can be an Area3D node

## -- Feel free to change everything in this script -- ##

func _on_area_entered(area: Area3D) -> void:
	if not area is HitboxComponent: return
	var hitbox : HitboxComponent = area
	hitbox.take_damage(attack_damage)


func _ready() -> void:
	if weapon_type == WeaponTypes.MELEE:
		AREA.connect("area_entered", _on_area_entered)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		attack()

func attack() -> void:
	ANIMATION_PLAYER.play("attack")
	if weapon_type != WeaponTypes.PROJECTILE: return
	var new_projectile : Area3D = projectile_scene.instantiate()

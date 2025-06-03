extends MeshInstance3D

@export var ANIMATION_PLAYER : AnimationPlayer
@export var AREA : Area3D
@export var ATTACK_COMPONENT : AttackComponent
@export var attack_damage := 1
@export var knockback_force := 0
@export var stun_time := 0


func _on_area_entered(area: Area3D) -> void:
	if not area is HitboxComponent: return
	var hitbox : HitboxComponent = area
	hitbox.take_damage(attack_damage)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		ANIMATION_PLAYER.play("attack")

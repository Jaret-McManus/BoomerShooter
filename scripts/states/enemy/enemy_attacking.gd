extends EnemyState

const DECELERATION: float = 30
const ATTACK_LENGTH: float = 0.6
const WINDUP: float = 0.1

func enter() -> void:
	enemy.SPRITE.modulate = Color.BLUE
	
	DETECT_RAY.collide_with_areas = true
	DETECT_RAY.collide_with_bodies = false
	
	await get_tree().create_timer(WINDUP).timeout
	
	var collider: Object = DETECT_RAY.get_collider()
	if collider is HitboxComponent:
		collider.take_damage(3)
	
	await get_tree().create_timer(ATTACK_LENGTH).timeout
	
	enemy.SPRITE.modulate = Color.WHITE
	transition.emit(&"Following")	

func exit() -> void:
	DETECT_RAY.collide_with_areas = false
	DETECT_RAY.collide_with_bodies = true
	
func physics_process(delta: float) -> void:
	enemy.velocity.x = move_toward(enemy.velocity.x, 0, delta * DECELERATION)
	enemy.velocity.z = move_toward(enemy.velocity.z, 0, delta * DECELERATION)

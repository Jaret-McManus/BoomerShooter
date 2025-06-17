extends EnemyState

@export var ATTACK_RANGE: float = 1
@export var ATTACK_STRENGTH: int = 1
@export var WINDUP_TIMER : Timer
@export var HEALTH_COMPONENT : HealthComponent

const DECELERATION: float = 30
const ATTACK_LENGTH: float = 0.6
const WINDUP_TIME : float = 0.5


func _on_windup_timer_timeout() -> void:
	if HEALTH_COMPONENT.current_health <= 0: return
	if get_detect_ray_len() <= ATTACK_RANGE:
		var collider: Object = DETECT_RAY.get_collider()
		if collider is HitboxComponent:
			collider.take_damage(ATTACK_STRENGTH)
	
		await get_tree().create_timer(ATTACK_LENGTH).timeout
	
	transition.emit(&"Following")


func _ready() -> void:
	WINDUP_TIMER.wait_time = WINDUP_TIME
	WINDUP_TIMER.connect("timeout", _on_windup_timer_timeout)


func enter() -> void:
	enemy.SPRITE.modulate = Color.BLUE
	DETECT_RAY.collide_with_areas = true
	DETECT_RAY.collide_with_bodies = false
	WINDUP_TIMER.start()


func exit() -> void:
	enemy.SPRITE.modulate = Color.WHITE
	DETECT_RAY.collide_with_areas = false
	DETECT_RAY.collide_with_bodies = true


func physics_process(delta: float) -> void:
	enemy.velocity.x = move_toward(enemy.velocity.x, 0, delta * DECELERATION)
	enemy.velocity.z = move_toward(enemy.velocity.z, 0, delta * DECELERATION)

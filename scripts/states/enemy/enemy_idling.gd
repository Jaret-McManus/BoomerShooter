extends EnemyState

const DECELERATION: float = 15

func physics_process(delta: float) -> void:
	enemy.velocity.x = move_toward(enemy.velocity.x, 0, delta * DECELERATION)
	enemy.velocity.z = move_toward(enemy.velocity.z, 0, delta * DECELERATION)
	
	if enemy.target:
		transition.emit(&"Following")

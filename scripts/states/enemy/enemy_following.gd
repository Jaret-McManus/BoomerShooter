extends EnemyState

const SPEED: float = 4
const ACCELERATION: float = 16
@export var ATTACK_RANGE: float = 1

func physics_process(delta: float) -> void:
	if not enemy.target: 
		transition.emit(&"Idling")
		return
	
	var detect_ray_len: float = (DETECT_RAY.get_collision_point() - enemy.global_position).length()
	if detect_ray_len <= ATTACK_RANGE:
		transition.emit(&"Attacking")
		return
	
	var speed: float = SPEED
	if enemy.current_sprite_direction != 0: 
		speed /= 2
			
	var direction_to_target: Vector3 = (enemy.target.position - enemy.global_position).normalized()
	#enemy.velocity = direction_to_target * SPEED * delta
	
	var vel_x := enemy.velocity.x
	var vel_z := enemy.velocity.z
	var target_vel := direction_to_target * speed
	enemy.velocity.x = move_toward(vel_x, target_vel.x, ACCELERATION * delta)
	enemy.velocity.z = move_toward(vel_z, target_vel.z, ACCELERATION * delta)

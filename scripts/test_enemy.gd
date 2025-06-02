extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += Global.GRAVITY * delta

	if randf() < 0.03:
		if randf() > 0.5:
			velocity.x += 3
		else:
			velocity.x -= 3
		
		if randf() < 0.5:
			velocity.z += 3
		else:
			velocity.z -= 3
	else:
		velocity *= 0.8

	move_and_slide()

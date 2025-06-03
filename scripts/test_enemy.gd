extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var SPRITE : Sprite3D

# 0 - 7 for the 8 directions to be animated
var current_sprite_direction : int = 0


func _on_died() -> void:
	queue_free()


func _physics_process(delta: float) -> void:
	bilboard_sprite()
	set_sprite_direction()
	apply_gravity(delta)
	move_random_direction()
	move_and_slide()


func apply_gravity(delta) -> void:
	if not is_on_floor():
		velocity += Global.GRAVITY * delta


func move_random_direction() -> void:
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


#custom bilboard function to give us access to the 
#sprite rotation for 8-directional animation
func bilboard_sprite() -> void:
	#set the sprite to look at the player
	SPRITE.look_at(Vector3(
		Global.player.global_transform.origin.x, 
		SPRITE.global_transform.origin.y,
		Global.player.global_transform.origin.z
	))
	#flip the sprite to face the player
	SPRITE.rotation_degrees.y += 180


func set_sprite_direction() -> void:
	# set the sprite frame 0 - 7 based on the sprites y rotation
	var sprite_direction : int = round(SPRITE.rotation_degrees.y / 45.0)
	# set 8 to 0 since 360 and 0 are the same direction
	if sprite_direction == 8: sprite_direction = 0
	
	#if the sprite direction changes, apply the new sprite direction
	if sprite_direction == current_sprite_direction: return
	current_sprite_direction = sprite_direction

extends CharacterBody3D

const SPEED := 5.0
const JUMP_VELOCITY := 4.5
const ROTATION_SPEED := 110.0

@export var ANIMATION_PLAYER : AnimationPlayer
@export var SPRITE : Sprite3D
@export var SFX : AudioStreamPlayer3D

var target : Player = null
var current_sprite_direction : int = 0


func _on_player_spotted() -> void:
	target = Global.player


func _on_player_unspotted() -> void:
	target = null


func _on_damage_taken(_stun_time: float, is_dead:= false) -> void:
	SPRITE.modulate = Color.RED
	if !is_dead: SFX.play()
	await get_tree().create_timer(0.1).timeout
	if is_dead:
		queue_free()
	else:
		SPRITE.modulate = Color.WHITE


func _ready() -> void:
	rotation.y = randf_range(0.0, 364.99)


func _physics_process(delta: float) -> void:
	bilboard_sprite()
	set_sprite_direction()
	apply_gravity(delta)
	if target != null: look_at_player()
	move_random_direction()
	move_and_slide()


func look_at_player() -> void:
	var to_target : Vector3 = target.global_transform.origin - global_transform.origin
	to_target = to_target.normalized()
	var right : Vector3 = global_transform.basis.x
	var r_dot : float = to_target.dot(right) # same direction = 1.0, perpendicular = 0.0
	
	rotation_degrees.y += ROTATION_SPEED * r_dot * get_physics_process_delta_time()
	


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += Global.GRAVITY * delta


func move_random_direction() -> void:
	## need to rotate enemy based on movement direction
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
		SPRITE.global_transform.origin.y, #this line keeps the sprite's y-rotation
		Global.player.global_transform.origin.z
	))
	SPRITE.rotation_degrees.y += 180


func set_sprite_direction() -> void:
	# set the sprite frame 0 - 7 based on the sprites y rotation
	var sprite_direction : int = round(SPRITE.rotation_degrees.y / 45.0)
	# set 8 to 0 since 360 and 0 are the same direction
	if sprite_direction == 8: sprite_direction = 0
	
	#if the sprite direction changes, apply the new sprite direction
	if sprite_direction == current_sprite_direction: return
	current_sprite_direction = sprite_direction
	set_animation_frames(&"walk")


func set_animation_frames(animation_name: StringName) -> void:
	#duplicate and replace animation library
	var animation_library : AnimationLibrary = ANIMATION_PLAYER.get_animation_library(&"")
	animation_library = animation_library.duplicate()
	ANIMATION_PLAYER.remove_animation_library(&"")
	ANIMATION_PLAYER.add_animation_library(&"", animation_library)
	
	#duplicate and replace animation
	var animation : Animation = ANIMATION_PLAYER.get_animation(animation_name)
	animation = animation.duplicate()
	animation_library.remove_animation(animation_name)
	animation_library.add_animation(animation_name, animation)
	
	#modify animation
	var sprite_area : int = current_sprite_direction * 4
	animation.track_set_key_value(0, 0, 0 + sprite_area)
	animation.track_set_key_value(0, 1, 1 + sprite_area)
	animation.track_set_key_value(0, 2, 2 + sprite_area)
	animation.track_set_key_value(0, 3, 3 + sprite_area)

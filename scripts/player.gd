class_name Player
extends CharacterBody3D

@warning_ignore("unused_signal")
signal damage_taken(amount: int)
@warning_ignore("unused_signal")
signal healed(amount: int)

# Movement variables
var BASE_SPEED: float = 15.0
var BASE_ACCELERATION: float = 4 * BASE_SPEED
var BASE_DECELERATION: float = 11 * BASE_SPEED
var AIR_ACC_MULTIPLIER: float = 0.7
var DIR_CHANGE_ACC_MULT: float = 1.2
const JUMP_VELOCITY: float = 13.0
var FALLING_GRAVITY_MULT: float = 1.2
var RESPAWN_HEIGHT: float = -45.0

# Camera variables
var SENSITIVITY: float = 0.0020
var CAMERA_TILT: float = deg_to_rad(1)
var BASE_FOV := 75.0
var TOP_FOV := BASE_FOV * 1.05
var FOV_WEIGHT := 10.0

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D


func _on_died() -> void:
	pass


func _ready() -> void:
	Global.player = self


func _unhandled_input(event: InputEvent) -> void:
	## Moves the camera with mouse movement
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2 * 0.98, PI/2 * 0.98)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"kick"):
		$Head/Camera3D/Leg/AnimationPlayer.play(&"ArmatureAction")


func _physics_process(_delta: float) -> void:
	if self.position.y < RESPAWN_HEIGHT:
		self.position = Vector3(0, 1, 0)
		head.rotation.y = 0
		camera.rotation.x = 0


## Moves the player
func handle_movement(max_speed: float, acceleration: float, deceleration: float, delta: float) -> void:
	if Global.screen_manager.NOTE_LAYER.get_child_count() > 0: return
	## Could we try implementing a slower backwards speed and
	## a slower jump deceleration so when you're jumping you don't
	## just stop mid-air
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector(&"left", &"right", &"forward", &"backward")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction.length() < Global.epsilon:
		# not moving decelerate quickly
		velocity.x = velocity.move_toward(direction * max_speed, deceleration * delta).x
		velocity.z = velocity.move_toward(direction * max_speed, deceleration * delta).z
	else:
		# accelerate faster when changing direction
		var projected_vel: Vector3 = Vector3(velocity.x, 0.0, velocity.z)
		var dir_vel_angle: float = direction.angle_to(projected_vel)
		
		var acc: float = remap(dir_vel_angle, 0, PI, acceleration, acceleration * DIR_CHANGE_ACC_MULT)
		velocity.x = velocity.move_toward(direction * max_speed, acc * delta).x
		velocity.z = velocity.move_toward(direction * max_speed, acc * delta).z
	
	# Gravity
	if not self.is_on_floor():
		var descent_mult: float = 1.0 if velocity.y < 0 else FALLING_GRAVITY_MULT
		velocity += Global.GRAVITY * descent_mult * delta
	
	movement_camera_effects(delta)
	
	self.move_and_slide()


func movement_camera_effects(delta: float) -> void:
	# Camera tilt
	var right: float = velocity.dot(head.basis.x) / BASE_SPEED
	camera.rotation.z = remap(-right, -1, 1, -self.CAMERA_TILT, self.CAMERA_TILT)
	
	## It might be better to have the FOV shift only when moving forward
	## or have the FOV shift less
	# Camera FOV
	var desired_fov: float = remap(velocity.length(), 0, BASE_SPEED, BASE_FOV, TOP_FOV)
	camera.fov = lerp(camera.fov, desired_fov, FOV_WEIGHT * delta)

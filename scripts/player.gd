class_name Player
extends CharacterBody3D


var BASE_SPEED: float = 15.0
var BASE_ACCELERATION: float = 8 * BASE_SPEED
var BASE_DECELERATION: float = 11 * BASE_SPEED
var AIR_ACC_MULTIPLIER: float = 0.7
const JUMP_VELOCITY: float = 13
var SENSITIVITY: float = 0.0020

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D


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

## Moves the player
func handle_movement(max_speed: float, acceleration: float, deceleration: float, delta: float) -> void:
	## the acceleration in the player movement might be too high, 
	## 2 * BASE_ACCELERATION feels better for me but it might just be my bad computer
	## I think the acceleration should be higher when changing direction to feel less floaty
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector(&"left", &"right", &"forward", &"backward")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction != Vector3.ZERO:
		velocity.x = velocity.move_toward(direction * max_speed, acceleration * delta).x
		velocity.z = velocity.move_toward(direction * max_speed, acceleration * delta).z
	else:
		var weight := 1 - exp(-deceleration) * delta
		velocity.x = velocity.move_toward(direction * max_speed, weight).x
		velocity.z = velocity.move_toward(direction * max_speed, weight).z

	# Gravity
	if not self.is_on_floor():
		var descent_mult: float = 1.0 if velocity.y < 0 else 1.2
		velocity += Global.GRAVITY * descent_mult * delta
	
	# Camera tilt
	
	
	self.move_and_slide()

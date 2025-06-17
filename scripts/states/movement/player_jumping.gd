extends PlayerState

@onready var SPEED: float = player.BASE_SPEED
@onready var ACCELERATION: float = player.BASE_ACCELERATION * player.AIR_ACC_MULTIPLIER
@onready var DECELERATION: float = player.BASE_DECELERATION * player.AIR_ACC_MULTIPLIER
@onready var JUMP_VEL: float = player.JUMP_VELOCITY


func enter() -> void:
	player.velocity.y += JUMP_VEL


func exit() -> void:
	pass


func process(_delta: float) -> void:
	pass


func physics_process(delta: float) -> void:
	player.handle_movement(SPEED, ACCELERATION, DECELERATION, delta)

	if player.velocity.length() < 0.001:
		transition.emit(&"Idling")
	elif player.is_on_floor():
		transition.emit(&"Walking")


func input(_event: InputEvent) -> void:
	pass

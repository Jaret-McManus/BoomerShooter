extends PlayerState

@onready var SPEED: float = player.BASE_SPEED
@onready var ACCELERATION: float = player.BASE_ACCELERATION
@onready var DECELERATION: float = player.BASE_DECELERATION

func enter() -> void:
	pass


func exit() -> void:
	pass


func process(_delta: float) -> void:
	pass


func physics_process(delta: float) -> void:
	player.handle_movement(SPEED, ACCELERATION, DECELERATION, delta)
	
	if player.velocity.length() > 0:
		transition.emit(&"Walking")
	elif Input.is_action_just_pressed("jump") and player.is_on_floor():
		transition.emit(&"Jumping")


func input(_event: InputEvent) -> void:
	pass

class_name MovementStateMachine extends StateMachine

@export var player: Player
func _ready() -> void:
	super._ready()
	for state: State in get_children():
		state.player = player

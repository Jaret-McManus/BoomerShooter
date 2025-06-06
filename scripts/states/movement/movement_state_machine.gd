class_name MovementStateMachine extends StateMachine

@export var player: Player
func _ready() -> void:
	super._ready()
	for state: State in get_children():
		state.player = player

func transition(next_state: StringName) -> void:
	Debug.update_debug(&"Current State", next_state)
	super.transition(next_state)

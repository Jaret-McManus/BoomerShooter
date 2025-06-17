class_name MovementStateMachine extends StateMachine

@export var player: Player

func transition(next_state: StringName) -> void:
	Debug.update_debug(&"Current State", next_state)
	super.transition(next_state)

class_name State extends Node

## signal to transition to a next state
@warning_ignore("unused_signal")
signal transition(next_state: StringName)


## Enter a state and possibly run code
func enter() -> void:
	pass


## Exit a state and possibly run code
func exit() -> void:
	pass


## Run process loop on state
func process(_delta: float) -> void:
	pass


## Run physics process loop on state
func physics_process(_delta: float) -> void:
	pass


## Handle input for a state
func input(_event: InputEvent) -> void:
	pass

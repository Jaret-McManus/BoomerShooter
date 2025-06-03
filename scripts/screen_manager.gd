extends Node


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"esc_mouse"):
		switch_mouse_capture_mode(Input.mouse_mode == Input.MOUSE_MODE_CAPTURED)


func switch_mouse_capture_mode(is_captured: bool) -> void:
	if is_captured:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

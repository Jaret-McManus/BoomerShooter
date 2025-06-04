class_name ScreenManager
extends Node

const NOTE_SCREEN : PackedScene = preload("res://scenes/note_screen.tscn")

@export var NOTE_LAYER : CanvasLayer


func _ready() -> void:
	Global.screen_manager = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"esc_mouse"):
		if NOTE_LAYER.get_child_count() > 0:
			NOTE_LAYER.get_child(0).queue_free()
		else: 
			switch_mouse_capture_mode(Input.mouse_mode == Input.MOUSE_MODE_CAPTURED)
	
	if event.is_action_pressed(&"debug_toggle"):
		Debug.DEBUG_MODE = not Debug.DEBUG_MODE
		Debug.panel.visible = Debug.DEBUG_MODE


func switch_mouse_capture_mode(is_captured: bool) -> void:
	if is_captured:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func show_note(note_text: Array[String]) -> void:
	var new_note : NoteScreen = NOTE_SCREEN.instantiate()
	NOTE_LAYER.add_child(new_note)
	new_note.display_note(note_text)
	

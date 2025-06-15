class_name ScreenManager
extends Node

const NOTE_SCREEN : PackedScene = preload("res://scenes/note_screen.tscn")

@export var NOTE_LAYER : CanvasLayer


func _ready() -> void:
	GlobalNodes.screen_manager = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"esc_mouse"):
		if NOTE_LAYER.get_child_count() > 0:
			NOTE_LAYER.get_child(0).queue_free()
		else: 
			switch_window_mode()
	
	if event.is_action_pressed(&"debug_toggle"):
		Debug.DEBUG_MODE = not Debug.DEBUG_MODE
		Debug.panel.visible = Debug.DEBUG_MODE


func _process(_delta: float) -> void:
	## -- fullscreen makes the game run at 25-30FPS for me, but windowed stays at 57-60FPS -- ##
	# I set max FPS to 60
	Debug.update_debug(&"FPS", Engine.get_frames_per_second())


func switch_window_mode() -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func show_note(note_text: Array[String]) -> void:
	var new_note : NoteScreen = NOTE_SCREEN.instantiate()
	NOTE_LAYER.add_child(new_note)
	new_note.display_note(note_text)
	

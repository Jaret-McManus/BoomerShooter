class_name NoteScreen
extends ColorRect

@export var NOTE_LABEL : Label

func display_note(note_text : Array[String]) -> void:
	for i in note_text:
		NOTE_LABEL.text += i
		NOTE_LABEL.text += "\n"

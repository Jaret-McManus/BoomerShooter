class_name SoundComponent 
extends Node

@export var sound_uids: Dictionary[StringName, String]
@export var SFX: AudioStreamPlayer3D


func _ready() -> void:
	pass


func play_sound(sound: StringName) -> void:
	SFX.stream = load(sound_uids[sound])
	SFX.play()

extends Node

const LEVEL_SCENES := {
	"test_level": preload("res://scenes/test_level.tscn")
}

@export var LEVEL_VIEWPORT : SubViewport


func load_level(level_scene: PackedScene) -> void:
	var level : Level = level_scene.instantiate()
	if LEVEL_VIEWPORT.get_child_count() > 0:
		for child in LEVEL_VIEWPORT.get_children():
			child.queue_free()
	LEVEL_VIEWPORT.add_child(level)

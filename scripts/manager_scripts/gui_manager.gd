class_name GUIManager
extends CanvasLayer

@export var health_indicator : TextureRect
@export var sanity_indicator : TextureRect
#we can replace these labels with image-based stuff later
@export var health_label : Label
@export var sanity_label : Label


func _ready() -> void:
	#there's probably a better way to do this
	GlobalNodes.gui_manager = self

func set_health(health: int) -> void:
	health_label.text = str(health)

func set_sanity(sanity: int) -> void:
	sanity_label.text = str(sanity)

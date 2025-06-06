extends Panel


func _ready() -> void:
	Debug.panel = self
	Debug.vbox = $MarginContainer/VBoxContainer
	self.visible = Debug.DEBUG_MODE

extends Area3D

signal collected

@export var SPRITE : Sprite3D
@export var TEXTURE : CompressedTexture2D


func _on_body_entered(body: Node3D) -> void:
	if not body is Player: return
	collected.emit()


func _ready() -> void:
	SPRITE.texture = TEXTURE
	body_entered.connect(_on_body_entered)

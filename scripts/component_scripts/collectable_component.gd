extends Node

enum Types {NOTE, POTION, WEAPON, AMMO}
@export var COLLECTABLE_TYPE : Types

## I need to change how this works so I only have to change
## out the script on the resource and not have a unique script
## and resource for every unique collectable
@export var COLLECTABLE : Resource


func _on_collected() -> void:
	match COLLECTABLE_TYPE:
		Types.NOTE: 
			GlobalNodes.screen_manager.show_note(COLLECTABLE.text)
			get_parent().queue_free()
		Types.POTION: pass
		Types.WEAPON: pass
		Types.AMMO: pass


func _ready() -> void:
	get_parent().connect("collected", _on_collected)

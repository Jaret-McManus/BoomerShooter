extends Node

var DEBUG_MODE := true
var panel: Panel
var vbox: VBoxContainer
var debug_dict: Dictionary[StringName, DebugRow] = {}

class DebugRow extends HBoxContainer:
	var name_lbl: Label
	var value_lbl: Label
	
	var value: Variant:
		set(val):
			value = val
			value_lbl.text = str(val)
	
	static func create(debug_name: StringName, val: Variant) -> DebugRow:
		var debug_row := DebugRow.new()
		
		debug_row.name_lbl = Label.new()
		debug_row.value_lbl = Label.new()
		
		debug_row.name_lbl.text = "%s:" % debug_name
		debug_row.value_lbl.text = str(val)
		debug_row.value = val
		
		debug_row.add_child(debug_row.name_lbl)
		debug_row.add_child(debug_row.value_lbl)
		
		return debug_row


func update_debug(debug_name: StringName, value: Variant = null) -> void:
	if not panel: return 
	
	if debug_name in debug_dict:
		var debug_row := debug_dict[debug_name]
		debug_row.value = value
	else:
		var new_debug_row := DebugRow.create(debug_name, value)
		debug_dict[debug_name] = new_debug_row
		vbox.add_child(new_debug_row)


func update_max_debug(debug_name: StringName, value: Variant = null) -> void:
	if not panel: return 
	
	if debug_name in debug_dict:
		var debug_row := debug_dict[debug_name]
		debug_row.value = max(debug_row.value, value)
	else:
		var new_debug_row := DebugRow.create(debug_name, value)
		debug_dict[debug_name] = new_debug_row
		vbox.add_child(new_debug_row)


func update_min_debug(debug_name: StringName, value: Variant = null) -> void:
	if not panel: return 
	
	if debug_name in debug_dict:
		var debug_row := debug_dict[debug_name]
		debug_row.value = min(debug_row.value, value)
	else:
		var new_debug_row := DebugRow.create(debug_name, value)
		debug_dict[debug_name] = new_debug_row
		vbox.add_child(new_debug_row)

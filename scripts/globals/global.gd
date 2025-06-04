extends Node

const GRAVITY: Vector3 = Vector3.DOWN * 35
var gui_manager : GUIManager
var screen_manager : ScreenManager
var player : CharacterBody3D
var epsilon: float = 1e-5

extends Area3D

signal player_spotted()
signal player_unspotted

@export var DETECT_RAY : RayCast3D

var is_player_visible : bool = false


func _on_body_entered(body: Node3D) -> void:
	if not body is Player: return
	DETECT_RAY.enabled = true


func _on_body_exited(body: Node3D) -> void:
	if not body is Player: return
	DETECT_RAY.enabled = false
	is_player_visible = false
	player_unspotted.emit()


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	player_spotted.connect(Callable(get_parent(), "_on_player_spotted"))
	player_unspotted.connect(Callable(get_parent(), "_on_player_unspotted"))


func _process(_delta: float) -> void:
	if DETECT_RAY.enabled == false: return
	
	var head_origin: Vector3 = Global.player.head.global_transform.origin
	DETECT_RAY.look_at(head_origin)
	
	#DETECT_RAY.rotation *= -1
	var ray_rot: Vector3 = DETECT_RAY.rotation
	DETECT_RAY.rotation = Vector3(-ray_rot.x, ray_rot.y + PI, -ray_rot.z)
	
	if DETECT_RAY.is_colliding():
		var collider : Node3D = DETECT_RAY.get_collider()
		if collider is Player:
			if is_player_visible == false:
				is_player_visible = true
				player_spotted.emit()
		else:
			if is_player_visible:
				is_player_visible = false
				player_unspotted.emit()

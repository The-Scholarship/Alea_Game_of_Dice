extends Node3D

# ------------------------------
# Variables and Signals
# ------------------------------

@onready var result_label = $CanvasLayer/ResultLabel
@onready var die = $Die
@onready var camera = $Camera3D

var _grabbed: bool = false
var _throw_vel: Vector3 = Vector3.ZERO
var _last_world_pos: Vector3 = Vector3.ZERO
var _grab_height: float = 0.0

# ------------------------------
# Input function
# ------------------------------

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_try_grab(event.position)
		elif _grabbed:
			_grabbed = false
			_release()

# ------------------------------
# Grab and Release functions
# ------------------------------

func _try_grab(screen_pos: Vector2):
	if die.is_rolling:
		return
	var from = camera.project_ray_origin(screen_pos)
	var to = from + camera.project_ray_normal(screen_pos) * 1000.0
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	if result and result.collider == die:
		_grabbed = true
		_grab_height = die.global_position.y
		_last_world_pos = die.global_position
		_throw_vel = Vector3.ZERO
		die.grab()

func _release():
	var direction = _throw_vel.normalized()
	var speed = clamp(_throw_vel.length() * 0.1, 5.0, die.roll_strength)
	die.throw(direction, speed)

func _mouse_to_world(screen_pos: Vector2) -> Vector3:
	var from = camera.project_ray_origin(screen_pos)
	var dir = camera.project_ray_normal(screen_pos)
	var t = (_grab_height - from.y) / dir.y
	return from + dir * t	

func _process(delta):
	if _grabbed:
		var world_pos = _mouse_to_world(get_viewport().get_mouse_position())
		world_pos.x = clamp(world_pos.x, -25.0, 25.0)
		world_pos.z = clamp(world_pos.z, -25.0, 13.0)
		_throw_vel = (world_pos - _last_world_pos) / delta
		_last_world_pos = world_pos
		die.global_position = world_pos

# ------------------------------
# Die roll result function
# ------------------------------

func _on_die_roll_finished(value):
	result_label.text = str(value)

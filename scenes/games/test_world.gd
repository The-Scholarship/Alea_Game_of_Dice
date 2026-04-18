extends Node3D

# ------------------------------
# Variables and Signals
# ------------------------------

@onready var result_label = $CanvasLayer/ResultLabel
@onready var die = $Die
@onready var camera = $Camera3D

var _grabbed: bool = false
var _mouse_vel: Vector2 = Vector2.ZERO
var _last_mouse_pos: Vector2 = Vector2.ZERO

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
	var to = from + camera.project_ray_normal(screen_pos) * 1000
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	if result and result.collider == die:
		_grabbed = true
		_last_mouse_pos = screen_pos
		_mouse_vel = Vector2.ZERO
		die.grab()

func _release():
	var direction = Vector3(_mouse_vel.x, 0, _mouse_vel.y).normalized()
	var speed = clamp(_mouse_vel.length() * 0.02, 5.0, die.roll_strength)
	die.throw(direction, speed)

func _process(delta):
	if _grabbed:
		var mouse_pos = get_viewport().get_mouse_position()
		_mouse_vel = (mouse_pos - _last_mouse_pos) / delta
		_last_mouse_pos = mouse_pos

# ------------------------------
# Die roll result function
# ------------------------------

func _on_die_roll_finished(value):
	result_label.text = str(value)

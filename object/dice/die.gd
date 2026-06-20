extends RigidBody3D

# ------------------------------
# Variables and Signals
# ------------------------------

@onready var raycasts = $Raycasts.get_children()

var start_pos
var roll_strength = 30
var is_rolling = false

signal roll_finished(value)

# ------------------------------
# Ready function
# ------------------------------

func _ready():
	start_pos = global_position

# ------------------------------
# Roll and Throw functions
# ------------------------------

func grab():
	freeze_mode = FREEZE_MODE_KINEMATIC
	freeze = true
	is_rolling = false

func throw(direction: Vector3, speed: float):
	_roll(direction, speed)

func _roll(direction: Vector3, speed: float):
	
	if direction == Vector3.ZERO:
		direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()

	sleeping = false
	freeze = false
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	
	transform.basis = Basis(Vector3.RIGHT, randf_range(0, 2 * PI)) * transform.basis
	transform.basis = Basis(Vector3.UP, randf_range(0, 2 * PI)) * transform.basis
	transform.basis = Basis(Vector3.FORWARD, randf_range(0, 2 * PI)) * transform.basis
	
	angular_velocity = direction * roll_strength / 2
	apply_central_impulse(direction * speed)
	is_rolling = true

func _on_sleeping_state_changed() -> void:
	if sleeping:
		var landed_on_side = false
		for raycast in raycasts:
			if raycast.is_colliding():
				roll_finished.emit(raycast.opposite_side)
				is_rolling = false
				landed_on_side = true
				
		if !landed_on_side:	
			var random_dir = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
			_roll(random_dir, roll_strength)

extends Spatial

var body_to_move : KinematicBody = null

# Moving variables
export var move_accel = 4
export var max_speed = 25
var drag = 0.0
export var jump_force = 30
export var gravity = 60

var pressed_jump = false
var move_vec : Vector3
var velocity : Vector3
# controls how you stick to the ground
var snap_vec : Vector3
export var ignore_rotation = false

# from this node we will pass info to the world
signal movement_info

# when characters dies
var is_frozen = false

func _ready():
	drag = float(move_accel) / max_speed

func init(_body_to_move: KinematicBody):
	body_to_move = _body_to_move

func jump():
	pressed_jump = true

func set_move_vec(_move_vec: Vector3):
	# https://godotengine.org/qa/46967/what-did-function-normalized-do
	move_vec = _move_vec.normalized()

# Lag independent
func _physics_process(delta):
	# if frozen, don't do anything
	if is_frozen:
		return
		
	var cur_move_vec = move_vec
	
	# watch a youtube video if you're stuck again..
	if !ignore_rotation:
		cur_move_vec = cur_move_vec.rotated(Vector3.UP, body_to_move.rotation.y)
		
	velocity += move_accel * cur_move_vec - velocity * Vector3(drag, 0, drag) + gravity * Vector3.DOWN * delta
	# keeps you snapped to the ground
	velocity = body_to_move.move_and_slide_with_snap(velocity, snap_vec, Vector3.UP)
	
	# returns true if the body is on the floor
	var is_grounded = body_to_move.is_on_floor()
	
	if is_grounded:
		# anything but 0 or 1, always want to move down to keep grounded^ updated
		velocity.y = -0.01
	if is_grounded and pressed_jump:
		velocity.y = jump_force
		# you won't stick to the ground if you're jumping
		snap_vec = Vector3.ZERO
	else:
		snap_vec = Vector3.DOWN
	# jump will be active for 1 frame only
	pressed_jump = false
	emit_signal("movement_info", velocity, is_grounded)

func freeze():
	is_frozen = true

func unfreeze():
	is_frozen = false


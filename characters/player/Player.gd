extends KinematicBody

export var mouse_sens = 0.5

onready var camera = $Camera
onready var character_mover = $CharacterMover
onready var health_manager = $HealthManager

var is_dead = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	character_mover.init(self)
	health_manager.init()
	# adding the signal
	health_manager.connect("dead", self, "kill")

# Runs every frame, delta is the time since the last frame
func _process(_delta):
	# Exit pressed - close the game
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

	#TODO: Game over screen		
	if is_dead:
		return

	# Keyboard inputs
	var move_vec = Vector3()
	if Input.is_action_pressed("move_forwards"):
		move_vec += Vector3.FORWARD
	if Input.is_action_pressed("move_backwards"):
		move_vec += Vector3.BACK
	if Input.is_action_pressed("move_left"):
		move_vec += Vector3.LEFT
	if Input.is_action_pressed("move_right"):
		move_vec += Vector3.RIGHT
	character_mover.set_move_vec(move_vec)
	if Input.is_action_just_pressed("jump"):
		character_mover.jump()

# Mouse inputs
func _input(event):
	# Any mouse related input
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouse_sens * event.relative.x
		camera.rotation_degrees.x -= mouse_sens * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
		
func hurt(damage, direction):
	health_manager.hurt(damage, direction)
	
func heal(amount):
	health_manager.heal(amount)

func kill():
	is_dead = true
	character_mover.freeze()

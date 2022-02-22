extends KinematicBody

export var mouse_sens = 0.5

onready var camera = $Camera
onready var character_mover = $CharacterMover
onready var health_manager = $HealthManager
onready var weapon_manager = $Camera/WeaponManager

var is_dead = false

var hotkeys = { 
	KEY_1: 0, 
	KEY_2: 1, 
	KEY_3: 2, 
	KEY_4: 3,
	KEY_5: 4, 
	KEY_6: 5, 
	KEY_7: 6, 
	KEY_8: 7,
	KEY_9: 8, 
	KEY_0: 9, 
}

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
	# Looking around with mouse
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouse_sens * event.relative.x
		camera.rotation_degrees.x -= mouse_sens * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
		
	# Take inputs for the weapons
	# Switching the weapon with the help of hotkeys
	if event is InputEventKey and event.pressed:
		if event.scancode in hotkeys:
			weapon_manager.switch_to_weapon_slot(hotkeys[event.scancode])
		# Switching the weapon by scrolling the wheel
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_DOWN:
			weapon_manager.switch_to_next_weapon()
		if event.button_index == BUTTON_WHEEL_UP:
			weapon_manager.switch_to_last_weapon()
			
		
func hurt(damage, direction):
	health_manager.hurt(damage, direction)
	
func heal(amount):
	health_manager.heal(amount)

func kill():
	is_dead = true
	character_mover.freeze()

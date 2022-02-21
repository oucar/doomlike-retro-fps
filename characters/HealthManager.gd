extends Spatial

# Signal regards to the current state
signal is_dead
signal is_hurt
signal is_healed
signal is_health_changed
signal is_gibbed

export var max_health = 100
var cur_health = 1

export var gib_at = -10

func _ready():
	init()

func init():
	# it is a better practice to set the current health to max health here
	cur_health = max_health
	emit_signal("health_changed", cur_health)

# Damage can come from x, y and/or z axis
# func hurt(damage: int, dir: Vector3, damage_type="fire"):
func hurt(damage: int, dir: Vector3):
	if cur_health <= 0:
		return
	else:
		cur_health -= damage
		
	if cur_health <= gib_at:
		pass #TODO make gibs spawner
		emit_signal("gibbed")
	if cur_health <= 0:
		emit_signal("dead")
		print('dead')
	else:
		emit_signal("hurt")
	emit_signal("health_changed")
	print('hurt ', damage, 'current health: ', cur_health)
	
func heal(amount: int):
	# dead
	if cur_health <= 0:
		return
	else: 
		cur_health += amount
	if cur_health > max_health:
		cur_health = max_health
	print('healed ', amount, 'current health: ', cur_health)
	emit_signal("healed")
	emit_signal("health_changed")

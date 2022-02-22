extends Spatial

onready var weapons = $Weapons.get_children()

# Different types of weapons i'll be using
enum WEAPON_SLOTS {MACHETE, MACHINE_GUN, SHOTGUN, ROCKET_LAUNCHER}

# will be locked if the gun is already picked up
var slots_unlocked = {
	WEAPON_SLOTS.MACHETE: true,
	WEAPON_SLOTS.MACHINE_GUN: true,
	WEAPON_SLOTS.SHOTGUN: true,
	WEAPON_SLOTS.ROCKET_LAUNCHER: true,
}

var cur_slot = 0
var cur_weapon = null

func _ready():
	pass

func switch_to_next_weapon():
	# 0, 1, 2, 3, 0...
	cur_slot = (cur_slot + 1) % slots_unlocked.size()
	# if current slot is not unlocked
	if !slots_unlocked[cur_slot]:
		switch_to_next_weapon()
	else:
		switch_to_weapon_slot(cur_slot)

# Select the last weapon with Q
func switch_to_last_weapon():
	# posmod -> % but always rounds to positive
	cur_slot = posmod((cur_slot - 1), slots_unlocked.size())
	if !slots_unlocked[cur_slot]:
		switch_to_last_weapon()
	else:
		switch_to_weapon_slot(cur_slot)

# Being able to use a weapon by selecting 1 2 3 4 5 
func switch_to_weapon_slot(slot_ind: int):
	# example: hotkey 9 will not do anything 
	if slot_ind < 0 or slot_ind >= slots_unlocked.size():
		return
	if !slots_unlocked[cur_slot]:
		return
	disable_all_weapons()
	cur_weapon = weapons[slot_ind]
	if cur_weapon.has_method("set_active"):
		cur_weapon.set_active()
	else:
		cur_weapon.show()

func disable_all_weapons():
	for weapon in weapons:
		# testing purposes only
		if weapon.has_method("set_inactive"):
			weapon.set_inactive()
		else:
			weapon.hide()

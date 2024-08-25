extends Node2D

var ALIVE = true

var HP = 10:
	set(val):
		HP = clamp(val, 0, 100)
		$HPLabel.text = str(HP)
		if HP == 0:
			combatant_death()


var BASE_INIT = 10:
	set(val):
		BASE_INIT = val
		INIT = val
var INIT = 10

var AI = true

var SKILLS = [
	DATA.BASE_ATTACK
]

signal combatantDeath

func set_combatant_color(color : Color):
	$CombatantSprite.modulate = color


func acivity_arrow_status(status):
	$ActiveArrow.visible = status


func combatant_death():
	combatantDeath.emit()
	ALIVE = false
	modulate.a = 0.5

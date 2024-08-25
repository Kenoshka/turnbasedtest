extends Node


enum {
	HP,
	INIT,
	COLOR
}


var COMBATANTS = [
	[15, 8, Color.YELLOW],
	[16, 6, Color.CYAN],
	[17, 4, Color.RED],
	[18, 5, Color.GREEN],
	[19, 7, Color.ORANGE],
	[20, 8, Color.VIOLET],
	[21, 6, Color.BLUE],
	[22, 4, Color.BROWN],
	[23, 5, Color.PINK],
	[24, 7, Color.BLUE_VIOLET],
]


enum {
	BASE_ATTACK
}


enum {
	SKILL_NAME,
	SKILL_SCN
}


var SKILLS = {
	BASE_ATTACK:["Base Attack" ,BaseAttack]
}

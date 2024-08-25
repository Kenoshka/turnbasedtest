extends Node2D

var combatant_scene = preload("res://Source/Combatant.tscn")

var combatants = []

var ENEMIES = []
var PARTY = []

signal targetChosen


var SKILL_CHOSEN = null
var TARGET = null:
	set(val):
		TARGET = val
		if val != null:
			$TargetArrow.global_position = TARGET.global_position
			$TargetArrow.global_position.y -= 50

var target_counter = 0

func _ready() -> void:
	randomize()
	create_combatants()
	start_round()


func create_combatants():
	DATA.COMBATANTS.shuffle()
	var enemies = DATA.COMBATANTS.slice(0, 4)
	var party = DATA.COMBATANTS.slice(4, 8)
	for comb in range(enemies.size()):
		var comb_scn = combatant_scene.instantiate()
		comb_scn.HP = DATA.COMBATANTS[comb][DATA.HP]
		comb_scn.BASE_INIT = DATA.COMBATANTS[comb][DATA.INIT]
		comb_scn.set_combatant_color(DATA.COMBATANTS[comb][DATA.COLOR])
		$Enemies.add_child(comb_scn)
		comb_scn.global_position = $EnemiesPos.get_child(comb).global_position
		ENEMIES.append(comb_scn)
		comb_scn.combatantDeath.connect(combatant_death.bind(comb_scn))
	for comb in range(party.size()):
		var comb_scn = combatant_scene.instantiate()
		comb_scn.HP = party[comb][DATA.HP]
		comb_scn.BASE_INIT = party[comb][DATA.INIT]
		comb_scn.AI = false
		comb_scn.set_combatant_color(party[comb][DATA.COLOR])
		$Party.add_child(comb_scn)
		comb_scn.global_position = $PartyPos.get_child(comb).global_position
		PARTY.append(comb_scn)
		comb_scn.combatantDeath.connect(combatant_death.bind(comb_scn))


func start_round():
	set_initiative()
	start_turns()


func start_turns():
	if PARTY.size() == 0:
		$CanvasLayer/ResultScreen/ResultLabel.text = "You lose!"
		$CanvasLayer/ResultScreen.visible = true
		return
	elif ENEMIES.size() == 0:
		$CanvasLayer/ResultScreen/ResultLabel.text = "You win!"
		$CanvasLayer/ResultScreen.visible = true
		return
	if combatants.size() != 0:
		var comb = combatants[0]
		comb.acivity_arrow_status(true)
		if comb.AI == true:
			var skill = DATA.SKILLS[comb.SKILLS[0]][DATA.SKILL_SCN].new()
			skill.caster = comb
			skill.target = PARTY.pick_random()
			add_child(skill)
			skill.start_skill()
			await skill.SkillEnd
		else:
			for skill in comb.SKILLS:
				var button = Button.new()
				button.text = DATA.SKILLS[skill][DATA.SKILL_NAME]
				$CanvasLayer/SkillsContainer.add_child(button)
				button.pressed.connect(skill_button_clicked.bind(skill))
			$CanvasLayer/SkillsContainer.visible = true
			await targetChosen
			for child in $CanvasLayer/SkillsContainer.get_children():
				child.queue_free()
			var skill = DATA.SKILLS[SKILL_CHOSEN][DATA.SKILL_SCN].new()
			skill.caster = comb
			skill.target = TARGET
			add_child(skill)
			skill.start_skill()
			await skill.SkillEnd
		comb.acivity_arrow_status(false)
		combatants.remove_at(0)
		start_turns()
	else:
		start_round()


func skill_button_clicked(skill):
	SKILL_CHOSEN = skill
	TARGET = ENEMIES[target_counter % ENEMIES.size()]
	$TargetArrow.visible = true
	$CanvasLayer/SkillsContainer.visible = false
	$CanvasLayer/TargetUI.visible = true


func _on_back_button_pressed() -> void:
	$TargetArrow.visible = false
	$CanvasLayer/SkillsContainer.visible = true
	$CanvasLayer/TargetUI.visible = false


func _on_attack_button_pressed() -> void:
	$TargetArrow.visible = false
	$CanvasLayer/SkillsContainer.visible = false
	$CanvasLayer/TargetUI.visible = false
	targetChosen.emit()


func set_initiative():
	for comb in ENEMIES:
		if comb.ALIVE:
			combatants.append(comb)
	for comb in PARTY:
		if comb.ALIVE:
			combatants.append(comb)
	for comb in combatants:
		comb.INIT = comb.BASE_INIT
		comb.INIT += randi_range(0, 3)
	combatants.shuffle()
	combatants.sort_custom(sort_initiative)
	print("Combatants order:")
	for comb in range(combatants.size()):
		print("%s - %s, %s initiative" % [comb + 1, combatants[comb].name, combatants[comb].INIT])
	print()


func sort_initiative(a, b):
	if a.INIT > b.INIT:
		return true
	return false


func _on_pointer_clicked(direction) -> void:
	target_counter += direction
	TARGET = ENEMIES[target_counter % ENEMIES.size()]


func combatant_death(combatant):
	if combatants.has(combatant):
		combatants.erase(combatant)
	if ENEMIES.has(combatant):
		ENEMIES.erase(combatant)
	if PARTY.has(combatant):
		PARTY.erase(combatant)

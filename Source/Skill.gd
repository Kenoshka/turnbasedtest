extends Node
class_name Skill

signal SkillEnd

var skill_timer = Timer.new()
var skill_time = 1

var skill_tw : Tween

var caster = null
var target = null


func start_skill():
	set_timer()
	handle_logic()
	animate_skill()


func set_timer():
	add_child(skill_timer)
	skill_timer.timeout.connect(end_skill)
	skill_timer.start(skill_time)


func handle_logic():
	pass


func animate_skill():
	pass


func end_skill():
	SkillEnd.emit()
	queue_free()


func skill_timeout():
	end_skill()

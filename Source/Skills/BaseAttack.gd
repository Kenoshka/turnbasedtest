extends Skill
class_name BaseAttack

func _ready() -> void:
	skill_time = 2

func handle_logic():
	var timer = get_tree().create_timer(skill_time / 2)
	await timer.timeout
	var damage = randi_range(1, 10)
	target.HP -= damage
	print("%s attacked %s, inflicited %s damage" % [caster.name, target.name, damage])


func animate_skill():
	var tw = create_tween()
	var default_pos = caster.global_position
	tw.tween_property(caster, "global_position", target.global_position, skill_time / 2)
	tw.tween_property(caster, "global_position", default_pos, skill_time / 2)

extends MarginContainer

#===============================================================================
# Abilities
#===============================================================================

func set_max_cooldown(ability, cooldown):
	if $VContainer/Abilities/Skill1/CenterContainer/TextureProgress == null:
		return
		
	match ability:
		1: 
			$VContainer/Abilities/Skill1/CenterContainer/TextureProgress.max_value = cooldown
		2: 
			$VContainer/Abilities/Skill2/CenterContainer/TextureProgress.max_value = cooldown
		3: 
			$VContainer/Abilities/Skill3/CenterContainer/TextureProgress.max_value = cooldown
		4: 
			$VContainer/Abilities/SkillUltimate/CenterContainer/TextureProgress.max_value = cooldown

func update_cooldown(ability, cooldown):
	if $VContainer/Abilities/Skill1/CenterContainer/TextureProgress == null:
		return
		
	match ability:
		1:
			$VContainer/Abilities/Skill1/CenterContainer/TextureProgress.value = cooldown
			if cooldown == 0:
				$VContainer/Abilities/Skill1/CenterContainer/Label.visible = false
			else:
				$VContainer/Abilities/Skill1/CenterContainer/Label.visible = true
				$VContainer/Abilities/Skill1/CenterContainer/Label.text = str(int(cooldown/10)+1)
		2: 			
			$VContainer/Abilities/Skill2/CenterContainer/TextureProgress.value = cooldown
			if cooldown == 0:
				$VContainer/Abilities/Skill2/CenterContainer/Label.visible = false
			else:
				$VContainer/Abilities/Skill2/CenterContainer/Label.visible = true
				$VContainer/Abilities/Skill2/CenterContainer/Label.text = str(int(cooldown/10)+1)
		3: 			
			$VContainer/Abilities/Skill3/CenterContainer/TextureProgress.value = cooldown
			if cooldown == 0:
				$VContainer/Abilities/Skill3/CenterContainer/Label.visible = false
			else:
				$VContainer/Abilities/Skill3/CenterContainer/Label.visible = true
				$VContainer/Abilities/Skill3/CenterContainer/Label.text = str(int(cooldown/10)+1)
		4: 			
			$VContainer/Abilities/SkillUltimate/CenterContainer/TextureProgress.value = cooldown
			if cooldown == 0:
				$VContainer/Abilities/SkillUltimate/CenterContainer/Label.visible = false
			else:
				$VContainer/Abilities/SkillUltimate/CenterContainer/Label.visible = true
				$VContainer/Abilities/SkillUltimate/CenterContainer/Label.text = str(int(cooldown/10)+1)
			
#===============================================================================
# Healthbar
#===============================================================================

func set_max_health(max_health):
	if $VContainer/Healthbar/TextureProgress == null:
		return
		
	$VContainer/Healthbar/TextureProgress.max_value = max_health

func update_health(health):
	if $VContainer/Healthbar/TextureProgress == null:
		return
		
	$VContainer/Healthbar/TextureProgress.value = health
	$VContainer/Healthbar/Label.text = str(health) + "/" + str($VContainer/Healthbar/TextureProgress.max_value)

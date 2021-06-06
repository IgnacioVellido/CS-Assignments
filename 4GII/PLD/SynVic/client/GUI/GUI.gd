extends MarginContainer

# Default texture of skill
var texture_skill_normal = preload("res://assets/GUI/skill1.png")

# Texture when a skill is being casted
var texture_skill_selected = preload("res://assets/GUI/skill1-selected.png")

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
			
func select_skill(ability):
	if $VContainer/Abilities/Skill1/CenterContainer/TextureProgress == null:
		return
		
	match ability:
		1: 
			$VContainer/Abilities/Skill1/CenterContainer/TextureProgress.texture_under = texture_skill_selected
		2: 
			$VContainer/Abilities/Skill2/CenterContainer/TextureProgress.texture_under = texture_skill_selected
		3: 
			$VContainer/Abilities/Skill3/CenterContainer/TextureProgress.texture_under = texture_skill_selected
		4: 
			$VContainer/Abilities/SkillUltimate/CenterContainer/TextureProgress.texture_under = texture_skill_selected			
	
func deselect_skill(ability):	
	if $VContainer/Abilities/Skill1/CenterContainer/TextureProgress == null:
		return
		
	match ability:
		1: 
			$VContainer/Abilities/Skill1/CenterContainer/TextureProgress.texture_under = texture_skill_normal
		2: 
			$VContainer/Abilities/Skill2/CenterContainer/TextureProgress.texture_under = texture_skill_normal
		3: 
			$VContainer/Abilities/Skill3/CenterContainer/TextureProgress.texture_under = texture_skill_normal
		4: 
			$VContainer/Abilities/SkillUltimate/CenterContainer/TextureProgress.texture_under = texture_skill_normal
	
func set_label_casting(ability, number):	# If number == -1, the label is hidden
	match ability:
		1:
			if number == -1:
				$VContainer/Abilities/Skill1/CenterContainer/LabelCasting.visible = false	
			else:
				$VContainer/Abilities/Skill1/CenterContainer/LabelCasting.visible = true
				$VContainer/Abilities/Skill1/CenterContainer/LabelCasting.text = str(number)			
		2:
			if number == -1:
				$VContainer/Abilities/Skill2/CenterContainer/LabelCasting.visible = false	
			else:
				$VContainer/Abilities/Skill2/CenterContainer/LabelCasting.visible = true
				$VContainer/Abilities/Skill2/CenterContainer/LabelCasting.text = str(number)	
		3:
			if number == -1:
				$VContainer/Abilities/Skill3/CenterContainer/LabelCasting.visible = false	
			else:
				$VContainer/Abilities/Skill3/CenterContainer/LabelCasting.visible = true
				$VContainer/Abilities/Skill3/CenterContainer/LabelCasting.text = str(number)	
		4:
			if number == -1:
				$VContainer/Abilities/SkillUltimate/CenterContainer/LabelCasting.visible = false	
			else:
				$VContainer/Abilities/SkillUltimate/CenterContainer/LabelCasting.visible = true
				$VContainer/Abilities/SkillUltimate/CenterContainer/LabelCasting.text = str(number)	
	
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

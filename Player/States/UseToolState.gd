extends State

# Variables pour gérer les outils
var tool_animation_finished = false
var current_tool = ""
var animation_time = 0.0
var tool_duration = 0.5  # durée en secondes de l'animation

func enter():
	# Déterminer quel outil est utilisé
	current_tool = player.get_current_tool()
	
	# Jouer l'animation appropriée selon l'outil et la direction
	var direction_suffix = ""
	match player.last_direction:
		Vector2.RIGHT:
			direction_suffix = "_right"
		Vector2.LEFT:
			direction_suffix = "_left"
		Vector2.UP:
			direction_suffix = "_up"
		Vector2.DOWN:
			direction_suffix = "_down"
	
	# Utiliser les animations Idle temporairement en attendant les animations d'outils
	player.animated_sprite.play("Idle" + direction_suffix)
	
	# Réinitialiser les variables
	tool_animation_finished = false
	animation_time = 0.0
	
	# Stopper le mouvement pendant l'utilisation de l'outil
	player.velocity = Vector2.ZERO

func update(delta):
	# Attendre que l'animation soit terminée
	animation_time += delta
	if animation_time >= tool_duration:
		tool_animation_finished = true
	
	# Appliquer l'effet de l'outil (par exemple labourer la terre)
	if animation_time >= tool_duration * 0.5 and not player.tool_effect_applied:
		apply_tool_effect()
		player.tool_effect_applied = true
	
	player.move_and_slide()

func apply_tool_effect():
	# Obtenir la position devant le joueur
	var target_pos = player.global_position + player.last_direction * 32  # 32 pixels devant
	
	# Vérifier ce qui se trouve à cette position (sol, plante, etc)
	var _space_state = player.get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = target_pos
	query.collision_mask = 2  # Layer des objets interactifs (changé de collision_layer à collision_mask)
	
	# Appliquer l'effet selon l'outil
	match current_tool:
		"hoe":
			# Convertir le sol en terre labourée
			# Exemple: player.world.till_soil(target_pos)
			pass
		"watering_can":
			# Arroser la plante ou le sol
			# Exemple: player.world.water_soil(target_pos)
			pass
		"axe":
			# Couper un arbre
			# Exemple: player.world.chop_tree(target_pos)
			pass
		"pickaxe":
			# Miner une pierre
			# Exemple: player.world.mine_rock(target_pos)
			pass

func transition():
	# Revenir à l'état idle quand l'animation est terminée
	if tool_animation_finished:
		return "IdleState"
	
	return null 
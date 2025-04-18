extends State

var interaction_finished = false
var interaction_object = null
var interaction_time = 0.0
var interaction_duration = 0.3  # Durée courte pour l'animation d'interaction

func enter():
	# Rechercher un objet interactif devant le joueur
	var target_pos = player.global_position + player.last_direction * 32
	
	# On pourrait utiliser un raycast ou une area2D pour détecter
	var space_state = player.get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = target_pos
	query.collision_mask = 4  # Layer des objets interactifs (changé de collision_layer à collision_mask)
	
	# Tenter de trouver un objet avec lequel interagir
	var result = space_state.intersect_point(query)
	if result.size() > 0:
		interaction_object = result[0].collider
	
	# Jouer l'animation d'interaction basée sur la direction
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
	
	# Idéalement une animation d'interaction
	player.animated_sprite.play("Idle" + direction_suffix)
	
	# Réinitialiser
	interaction_time = 0.0
	interaction_finished = false
	
	# Arrêter le mouvement pendant l'interaction
	player.velocity = Vector2.ZERO
	
	# Si on a trouvé un objet, démarrer l'interaction
	if interaction_object:
		start_interaction()

func update(_delta):
	interaction_time += _delta
	
	# Vérifier si l'interaction est terminée
	if interaction_time >= interaction_duration:
		interaction_finished = true
	
	player.move_and_slide()

func start_interaction():
	# Selon le type d'objet, démarrer différentes interactions
	if interaction_object.has_method("interact"):
		interaction_object.interact(player)
	
	# Types d'interactions possibles
	if interaction_object.is_in_group("npc"):
		# Démarrer un dialogue
		# Exemple: player.dialogue_system.start_dialogue(interaction_object.dialogue_id)
		pass
	elif interaction_object.is_in_group("shop"):
		# Ouvrir une boutique
		# Exemple: player.ui.open_shop(interaction_object.shop_id)
		pass
	elif interaction_object.is_in_group("chest"):
		# Ouvrir un coffre
		# Exemple: player.ui.open_storage(interaction_object.inventory)
		pass
	elif interaction_object.is_in_group("door"):
		# Ouvrir/fermer une porte
		# Exemple: interaction_object.toggle()
		pass
	elif interaction_object.is_in_group("bed"):
		# Se coucher pour passer au lendemain
		# Exemple: player.world.advance_day()
		pass

func transition():
	# Vérifier si on doit rester dans cet état
	if interaction_object and interaction_object.is_in_group("npc") and player.is_in_dialogue:
		# Rester dans cet état pendant un dialogue
		return null
		
	if interaction_finished:
		return "IdleState"
		
	return null 
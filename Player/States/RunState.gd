extends State

func enter():
	# L'animation sera définie dans update en fonction de la direction
	pass

func update(_delta):
	# Récupérer les entrées de direction
	var direction_x = Input.get_axis("ui_left", "ui_right")
	var direction_y = Input.get_axis("ui_up", "ui_down")
	
	# Calculer le vecteur de mouvement
	var movement = Vector2(direction_x, direction_y)
	
	# Normaliser pour éviter la vitesse plus rapide en diagonale
	if movement.length() > 1.0:
		movement = movement.normalized()
	
	# Appliquer le mouvement
	player.velocity = movement * player.SPEED
	
	# Gestion des animations et de la dernière direction
	if direction_x != 0:
		if direction_x > 0:
			player.animated_sprite.play("walk_right")
			player.last_direction = Vector2.RIGHT
		else:
			player.animated_sprite.play("walk_left")
			player.last_direction = Vector2.LEFT
	elif direction_y != 0:
		if direction_y < 0:
			player.animated_sprite.play("Walk_up")
			player.last_direction = Vector2.UP
		else:
			player.animated_sprite.play("Walk_down")
			player.last_direction = Vector2.DOWN
	
	# Déplacer le joueur
	player.move_and_slide()

func transition():
	# Vérifier les entrées pour décider si on change d'état
	var direction_x = Input.get_axis("ui_left", "ui_right")
	var direction_y = Input.get_axis("ui_up", "ui_down")
	
	if direction_x == 0 and direction_y == 0:
		return "IdleState"
	
	# Transitions pour les actions de farming, même en mouvement
	if Input.is_action_just_pressed("use_tool"):
		return "UseToolState"
	
	if Input.is_action_just_pressed("interact"):
		return "InteractState"
		
	return null 
extends State

func enter():
	# S'assurer que le player et le animated_sprite existent
	if player == null or not is_instance_valid(player):
		push_error("Player is null in IdleState.enter()")
		return
		
	if player.animated_sprite == null or not is_instance_valid(player.animated_sprite):
		push_error("AnimatedSprite is null in IdleState.enter()")
		return
		
	# Animation d'inactivité basée sur la dernière direction
	match player.last_direction:
		Vector2.RIGHT:
			player.animated_sprite.play("Idle_right")
		Vector2.LEFT:
			player.animated_sprite.play("Idle_left")
		Vector2.UP:
			player.animated_sprite.play("Idle_up")
		Vector2.DOWN:
			player.animated_sprite.play("Idle_down")
	
	# Arrêter le mouvement
	player.velocity = Vector2.ZERO

func update(_delta):
	# Vérifier si le joueur est toujours immobile
	player.move_and_slide()

func transition():
	# Vérifier les entrées pour décider si on change d'état
	var direction_x = Input.get_axis("ui_left", "ui_right")
	var direction_y = Input.get_axis("ui_up", "ui_down")
	
	if direction_x != 0 or direction_y != 0:
		return "RunState"
			
	return null 

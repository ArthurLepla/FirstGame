extends CharacterBody2D

const SPEED = 150.0


@onready var animated_sprite = $AnimatedSprite2D

var last_direction = Vector2.DOWN # Default to facing down

func _ready():

	velocity = Vector2.ZERO
	# Set initial animation
	animated_sprite.play("Idle_down") # Let's default to Idle_down initially

func _physics_process(_delta):
	# --- Movement Input ---
	var direction_x = Input.get_axis("Gauche", "Droite")
	var direction_y = Input.get_axis("Avancer", "Reculer") # Up(W) is Negative Y, Down(S) is Positive Y
	
	velocity = Vector2.ZERO
	var input_vector = Vector2(direction_x, direction_y)
	var is_moving = false

	if input_vector != Vector2.ZERO:
		is_moving = true
		velocity = input_vector.normalized() * SPEED
		# Update last_direction based on movement priority (horizontal > vertical)
		if direction_x != 0:
			last_direction = Vector2(sign(direction_x), 0)
		elif direction_y != 0:
			last_direction = Vector2(0, sign(direction_y))
	
	# --- Animation ---
	if is_moving:
		if last_direction == Vector2.RIGHT:
			animated_sprite.play("walk_right")
		elif last_direction == Vector2.LEFT:
			animated_sprite.play("walk_left")
		elif last_direction == Vector2.DOWN:
			animated_sprite.play("Walk_down")
		elif last_direction == Vector2.UP:
			animated_sprite.play("Walk_up")
	else:
		# Idle animation based on last direction
		if last_direction == Vector2.RIGHT:
			animated_sprite.play("Idle_right")
		elif last_direction == Vector2.LEFT:
			animated_sprite.play("Idle_left")
		elif last_direction == Vector2.DOWN:
			animated_sprite.play("Idle_down")
		elif last_direction == Vector2.UP:
			animated_sprite.play("Idle_up")


	# Move the player
	move_and_slide()

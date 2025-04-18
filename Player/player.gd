extends CharacterBody2D


const SPEED = 150.0
# const JUMP_VELOCITY = -400.0 # Not used for top-down
const TILE_SIZE = 16 # Assuming your tiles are 16x16 pixels

# Tile Information (Adjust if necessary based on your TileSet setup)
# const GRASS_SOURCE_ID = 0 # Old reference
# const GRASS_ATLAS_COORDS = Vector2i(1, 6) # Old reference
# const TILLED_DIRT_SOURCE_ID = 2 # Old reference
# const TILLED_DIRT_ATLAS_COORDS = Vector2i(1, 6) # Old reference
const TILEMAP_LAYER = 0 # Assuming you are using layer 0 of the TileMap

# Get the gravity from the project settings to be synced with RigidBody nodes.
# var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Gravité désactivée

@onready var animated_sprite = $AnimatedSprite2D
# TileMap principal (sol) pour calculer la position cible
@onready var tilemap: TileMap = get_node("/root/NightClearing/Environment/TileMap_Ground") # CORRECTED PATH
# @onready var target_indicator: Node2D = $TargetIndicator # Removed reference
var last_direction = Vector2.DOWN # Default to facing down

func _ready():
	# Print available animations to debug
	# print("Available animations: ", animated_sprite.sprite_frames.get_animation_names()) # Removed debug print
	# Initialize player with zero velocity
	velocity = Vector2.ZERO
	# Set initial animation
	animated_sprite.play("Idle_down") # Let's default to Idle_down initially
	
	# Ensure indicator exists
	# if target_indicator == null:
	# 	printerr("TargetIndicator node not found!")
	# 	# Optional: Disable indicator logic if node not found
	# 	# target_indicator = null # Or set a flag


# func _input(event): # Commenting out the old function
func _unhandled_input(event): # Using _unhandled_input instead
	# Check if the action for using a tool (left click mapped to "till" action) is pressed
	if event.is_action_pressed("till"):
		print("Action 'till' detected!") # DEBUG
		till_soil()


func _calculate_target_map_pos() -> Vector2i:
	# Calculate the tile position directly in front of the player based on last_direction
	var player_map_pos = tilemap.local_to_map(global_position)
	var target_map_pos = player_map_pos + Vector2i(last_direction)
	return target_map_pos


func till_soil():
	# print("--- TILL_SOIL FUNCTION ENTERED (SIMPLE TEST) ---") # DEBUG - Removed
	# --- Restoring logic below ---
	# Check if FarmManager autoload exists - REMOVED INCORRECT CHECK
	# if not Engine.has_singleton("FarmManager"):
	# 	printerr("FarmManager autoload singleton NOT found! Check Project Settings -> Autoload.")
	# 	return
	# print("Step 1: FarmManager singleton found.") # DEBUG - This step is now implicit
		
	# Check if the tilemap for position calculation is valid
	if tilemap == null:
		# This check might be redundant now if @onready fails, but kept for safety
		printerr("Player's TileMap reference (for position calculation) is NULL! Check @onready path.")
		return
	print("Step 2: Player's tilemap reference is valid.") # DEBUG

	# Use the calculated target position
	print("Step 3: Calculating target map position...") # DEBUG
	var target_map_pos = _calculate_target_map_pos()
	print("Step 4: Target position calculated:", target_map_pos) # DEBUG

	# Call FarmManager to handle the tilling logic and visual updat


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

	# --- Update Target Indicator Position --- (Section Removed)
	# Removed indicator update logic

	# Move the player
	move_and_slide()
	
	# Optional: Snap player position to grid after moving (can help with precision)
	# global_position = global_position.snapped(Vector2(TILE_SIZE, TILE_SIZE)) # Consider if snapping is desired
	# global_position = global_position.floor() # Old floor snapping removed

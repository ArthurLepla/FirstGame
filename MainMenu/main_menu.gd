extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Find the Play button node
	var play_button = find_child("PlayButton")
	if play_button:
		play_button.pressed.connect(_on_play_button_pressed)
	else:
		push_error("PlayButton node not found. Make sure you have a button named 'PlayButton' in your scene.")
		print("Add a Button node to your scene and name it 'PlayButton'")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Function to handle when the Play button is pressed
func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://World/world.tscn")

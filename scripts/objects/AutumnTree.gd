extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if sprite_frames.has_animation("default"):
		var frame_count = sprite_frames.get_frame_count("default")
		if frame_count > 0:
			frame = randi() % frame_count # Start at a random frame
		play("default") # Play the default animation
	else:
		push_warning("AutumnTree: 'default' animation not found!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

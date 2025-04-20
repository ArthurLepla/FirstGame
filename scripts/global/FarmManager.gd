extends Node2D

# On ne peut pas utiliser @onready ou $ car l'autoload n'a pas ce nœud comme enfant
var ground_tilemap : TileMap = null 

var grass_layer = 0
var crop_layer = 1
var terrain_layer_dirt_id = 1
var terrain_dirt_id = 0

var can_place_dirt_custom_data = "can_place_dirt"

var dirt_tiles = []


func _ready():
	# Attend que l'arbre de scène soit potentiellement chargé
	call_deferred("find_ground_tilemap")

func find_ground_tilemap():
	# Essaye de trouver le TileMap via son chemin depuis la racine de la scène
	var scene_root = get_tree().root
	ground_tilemap = scene_root.get_node_or_null("Environment/GroundTileMap") as TileMap
	if not ground_tilemap:
		# Essaye de trouver via la scène courante si la racine est différente (moins courant mais possible)
		var current_scene = get_tree().current_scene
		if current_scene:
			ground_tilemap = current_scene.get_node_or_null("Environment/GroundTileMap") as TileMap
		
	if not ground_tilemap:
		push_warning("FarmManager: TileMap node at path '/root/Environment/GroundTileMap' or in current scene not found.")

func _process(_delta):
	pass

func _input(event):
	# Vérifie si le tilemap a été trouvé
	if not ground_tilemap:
		# Tente de le retrouver si la scène a chargé après _ready
		find_ground_tilemap()
		if not ground_tilemap:
			print("FarmManager: ground_tilemap still not found in _input.")
			return # Sort si toujours pas trouvé
		
	if event.is_action_pressed("click"):
		var mouse_position = get_global_mouse_position()
		var local_mouse_pos = ground_tilemap.to_local(mouse_position)
		var tile_mouse_position : Vector2i = ground_tilemap.local_to_map(local_mouse_pos)
		var cells_to_update : Array[Vector2i] = [tile_mouse_position]
		if retrieving_custom_data(tile_mouse_position, can_place_dirt_custom_data, grass_layer):
			dirt_tiles.append(tile_mouse_position)
			ground_tilemap.set_cells_terrain_connect(crop_layer, dirt_tiles, terrain_layer_dirt_id, terrain_dirt_id)

func retrieving_custom_data(tile_mouse_position, custom_data_layer, layer):
	var cell_data = ground_tilemap.get_cell_tile_data(layer, tile_mouse_position)
	if cell_data:
		return cell_data.get_custom_data(custom_data_layer)
	else:
		return false

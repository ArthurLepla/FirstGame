extends Node2D

# Utilisation de get_node_or_null pour plus de robustesse
@onready var canvas_modulate := get_node_or_null("Environment/CanvasModulate")
# Cibler le DirectionalLight2D qui sert d'ombre/overlay nocturne
@onready var night_overlay_light := get_node_or_null("Environment/nightOverlay") 
# Références aux tilemaps
@onready var ground_tilemap := get_node_or_null("Environment/TileMap_Ground")
@onready var farm_overlay := get_node_or_null("Environment/TileMap_FarmOverlay")

# Constantes pour les couleurs et l'énergie
const DAY_AMBIENT_COLOR := Color(1.0, 1.0, 1.0)
const NIGHT_AMBIENT_COLOR := Color(0.1, 0.1, 0.2) # Teinte pour CanvasModulate
const NIGHT_SHADOW_COLOR := Color(0.1, 0.1, 0.2) # Teinte pour DirectionalLight2D (si besoin)
const DAY_SHADOW_ENERGY : float = 0.2  # Énergie minimale de l'ombre (journée)
const NIGHT_SHADOW_ENERGY : float = 0.6 # Énergie maximale de l'ombre (nuit)

# Dictionnaire pour les heures de lever/coucher du soleil par saison (normalisées 0.0-1.0)
# Structure: { Season: {"rise_start": float, "rise_end": float, "set_start": float, "set_end": float} }
const SEASON_TRANSITION_TIMES := {
	GameManager.Season.SPRING: {"rise_start": 0.25, "rise_end": 0.33, "set_start": 0.75, "set_end": 0.83}, # 6h-8h / 18h-20h
	GameManager.Season.SUMMER: {"rise_start": 0.21, "rise_end": 0.29, "set_start": 0.79, "set_end": 0.875},# 5h-7h / 19h-21h
	GameManager.Season.FALL:   {"rise_start": 0.25, "rise_end": 0.33, "set_start": 0.75, "set_end": 0.83}, # 6h-8h / 18h-20h (idem Spring)
	GameManager.Season.WINTER: {"rise_start": 0.29, "rise_end": 0.375,"set_start": 0.71, "set_end": 0.79} # 7h-9h / 17h-19h
}

# ID pour les types de terrain dans le tileset
enum TileType { GRASS, TILLED }

func _ready():
	print("NightClearing _ready() START") # DEBUG
	# Vérification initiale
	if not canvas_modulate:
		push_warning("Node 'Environment/CanvasModulate' not found in night_clearing scene.")
	if not night_overlay_light:
		push_warning("Node 'Environment/nightOverlay' (DirectionalLight2D) not found in night_clearing scene.")
	else:
		# Définir la couleur de l'ombre directionnelle une fois (si elle est fixe)
		night_overlay_light.color = NIGHT_SHADOW_COLOR

	# Setup TileMaps references
	print("NightClearing: Attempting to find TileMap nodes...") # DEBUG
	if not ground_tilemap:
		push_warning("Node 'Environment/TileMap_Ground' not found.")
	if not farm_overlay:
		push_warning("Node 'Environment/TileMap_FarmOverlay' not found.")
	

func _process(_delta):
	# Calculer le temps normalisé une seule fois
	var t := GameManager.get_time_normalized()
	
	# Récupérer la saison actuelle et les temps de transition correspondants
	var current_season = GameManager.current_season
	if not SEASON_TRANSITION_TIMES.has(current_season):
		push_error("Invalid season obtained from GameManager!")
		return # Ou utiliser une saison par défaut
		
	var times = SEASON_TRANSITION_TIMES[current_season]
	
	# Calculer la force de la nuit en fonction de la saison
	var night_strength := get_night_strength(t, times.rise_start, times.rise_end, times.set_start, times.set_end)

	# Contrôler CanvasModulate pour l'ambiance globale
	if canvas_modulate:
		canvas_modulate.color = DAY_AMBIENT_COLOR.lerp(NIGHT_AMBIENT_COLOR, night_strength)

	# Contrôler le DirectionalLight2D pour l'ombre dynamique
	if night_overlay_light:
		# Rotation simulant le soleil/lune (peut rester simple ou être complexifiée)
		# Le cycle jour/nuit est plus court, mais la rotation peut rester sur 24h pour le feeling
		night_overlay_light.rotation = lerp(-0.5 * PI, 1.5 * PI, t) 
		# Énergie de l'ombre (plus forte la nuit pour un light subtractif)
		night_overlay_light.energy = lerp(DAY_SHADOW_ENERGY, NIGHT_SHADOW_ENERGY, night_strength)
	
# Fonction refactorisée pour calculer la force de la nuit (0 = jour, 1 = nuit)
# Prend en compte les heures de lever/coucher spécifiques à la saison
func get_night_strength(t: float, sunrise_start: float, sunrise_end: float, sunset_start: float, sunset_end: float) -> float:
	# Lever du soleil
	if t >= sunrise_start and t < sunrise_end: 
		return 1.0 - smoothstep(sunrise_start, sunrise_end, t)
	# Coucher du soleil
	elif t >= sunset_start and t < sunset_end: 
		return smoothstep(sunset_start, sunset_end, t)
	# Journée (entre fin du lever et début du coucher)
	elif t >= sunrise_end and t < sunset_start: 
		return 0.0
	# Nuit (avant le lever ou après le coucher)
	else: 
		return 1.0

# Fonction appelée lorsque l'utilisateur clique sur la scène
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Assurer que les tilemaps sont présents
		if ground_tilemap:
			# Convertir la position de clic en coordonnées de cellule
			var click_position = get_global_mouse_position()
			var cell_coords = ground_tilemap.local_to_map(ground_tilemap.to_local(click_position))
			
			# Changer la cellule en "tilled" (labourée)
			# Note: Vous devrez ajuster ces valeurs selon votre tileset
			# Les coordonnées source (4, 0) représentent la terre labourée, ajustez selon votre tileset
			ground_tilemap.set_cell(0, cell_coords, 0, Vector2i(4, 0))
			
			print("Changing cell at ", cell_coords, " to tilled")

extends AnimatedSprite2D

# Référence vers la lumière du feu de camp
@onready var point_light := get_node_or_null("PointLight2D")

# Énergie de la lumière
const MIN_ENERGY_DAY: float = 0.4   # Énergie minimale pendant la journée
const MAX_ENERGY_NIGHT: float = 1.2 # Énergie maximale pendant la nuit

# Called when the node enters the scene tree for the first time.
func _ready():
	play("fire") # Start the "fire" animation
	if not point_light:
		push_warning("Child node 'PointLight2D' not found in Campfire.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Vérifier si la lumière existe
	if point_light:
		# Obtenir le temps normalisé (0.0 jour -> 1.0 nuit -> 0.0 jour)
		var t := GameManager.get_time_normalized()
		# Calculer la "force" de la nuit (0.0 jour, 1.0 nuit)
		var night_strength := _get_night_strength(t)
		# Interpoler l'énergie entre le min (jour) et le max (nuit)
		point_light.energy = lerp(MIN_ENERGY_DAY, MAX_ENERGY_NIGHT, night_strength)

# Fonction pour calculer l'intensité de la nuit (0 = jour, 1 = nuit)
# Similaire à celle dans night_clearing.gd
func _get_night_strength(t: float) -> float:
	# Transition douce matin (0.0 à 0.25 -> 1.0 à 0.0)
	if t < 0.25: # 0h00 à 6h00
		return 1.0 - smoothstep(0.0, 0.25, t) # Inversé par rapport à night_clearing
	# Transition douce soir (0.75 à 1.0 -> 0.0 à 1.0)
	elif t > 0.75: # 18h00 à 0h00
		return smoothstep(0.75, 1.0, t)
	# Pleine journée
	else: # 6h00 à 18h00
		return 0.0

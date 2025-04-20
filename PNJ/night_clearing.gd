extends Node2D

# Utilisation de get_node_or_null pour plus de robustesse
@onready var canvas_modulate := get_node_or_null("Environment/CanvasModulate")
# Cibler le DirectionalLight2D qui sert d'ombre/overlay nocturne
@onready var night_overlay_light := get_node_or_null("Environment/nightOverlay") 

# Constantes pour les couleurs et l'énergie
const DAY_AMBIENT_COLOR := Color(1.0, 1.0, 1.0)
const NIGHT_AMBIENT_COLOR := Color(0.1, 0.1, 0.2) # Teinte pour CanvasModulate
const NIGHT_SHADOW_COLOR := Color(0.1, 0.1, 0.2) # Teinte pour DirectionalLight2D (si besoin)
const DAY_SHADOW_ENERGY : float = 0.2  # Énergie minimale de l'ombre (journée)
const NIGHT_SHADOW_ENERGY : float = 0.6 # Énergie maximale de l'ombre (nuit)

func _ready():
	# Vérification initiale
	if not canvas_modulate:
		push_warning("Node 'Environment/CanvasModulate' not found in night_clearing scene.")
	if not night_overlay_light:
		push_warning("Node 'Environment/nightOverlay' (DirectionalLight2D) not found in night_clearing scene.")
	else:
		# Définir la couleur de l'ombre directionnelle une fois (si elle est fixe)
		night_overlay_light.color = NIGHT_SHADOW_COLOR

func _process(_delta):
	# Calculer le temps normalisé une seule fois
	var t := GameManager.get_time_normalized()
	var night_strength := get_night_strength(t)

	# Contrôler CanvasModulate pour l'ambiance globale
	if canvas_modulate:
		canvas_modulate.color = DAY_AMBIENT_COLOR.lerp(NIGHT_AMBIENT_COLOR, night_strength)

	# Contrôler le DirectionalLight2D pour l'ombre dynamique
	if night_overlay_light:
		# Rotation simulant le soleil/lune
		night_overlay_light.rotation = lerp(-0.5 * PI, 1.5 * PI, t)
		# Énergie de l'ombre (plus forte la nuit pour un light subtractif)
		night_overlay_light.energy = lerp(DAY_SHADOW_ENERGY, NIGHT_SHADOW_ENERGY, night_strength)
	
func get_night_strength(t: float) -> float:
	# Transition douce matin (0.0 à 0.2 -> 1.0 à 0.0)
	if t < 0.25: # 0h00 à 6h00
		return smoothstep(0.0, 0.25, t)
	# Transition douce soir (0.75 à 1.0 -> 0.0 à 1.0)
	elif t > 0.75: # 18h00 à 0h00
		return smoothstep(0.75, 1.0, t)
	# Pleine journée
	else: # 6h00 à 18h00
		return 0.0

class_name StateMachine
extends Node

# Signaux pour notifier les changements d'état
signal state_changed(previous_state, new_state)

# États disponibles dans le jeu
@export var initial_state: NodePath

# Référence à l'état actuel et au joueur
var current_state: State
var states: Dictionary = {}
@onready var player: CharacterBody2D = get_parent()

func _ready() -> void:
	# On construit le dictionnaire d'états
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.player = player
			child.state_machine = self
	
	# On définit l'état initial
	# Pas besoin d'attendre dans _ready
	if initial_state:
		current_state = get_node(initial_state)
		if current_state:
			current_state.enter()
		else:
			print("ERREUR: État initial non trouvé: ", initial_state)

func _process(delta):
	# On fait fonctionner l'état actuel
	if current_state:
		current_state.update(delta)
		
		# On vérifie si on doit changer d'état
		var new_state = current_state.transition()
		if new_state:
			change_state(new_state)

func _input(event):
	# On passe les inputs à l'état actuel
	if current_state:
		current_state.handle_input(event)

# Méthode pour changer d'état
func change_state(new_state_name: String):
	if not states.has(new_state_name.to_lower()):
		print("ERREUR: État non trouvé: ", new_state_name)
		return
		
	var previous_state = current_state
	
	if current_state:
		current_state.exit()
		
	current_state = states[new_state_name.to_lower()]
	current_state.enter()
	
	emit_signal("state_changed", previous_state, current_state) 

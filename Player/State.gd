class_name State
extends Node

# Référence au joueur
var player: CharacterBody2D
var state_machine: StateMachine

# Fonction appelée quand on entre dans l'état
func enter():
	pass

# Fonction appelée quand on quitte l'état
func exit():
	pass

# Logique principale de l'état, appelée à chaque frame
func update(_delta: float):
	pass

# Gestion des entrées utilisateur dans cet état
func handle_input(_event: InputEvent):
	pass

# Détermine si nous devons passer à un autre état
func transition():
	return null 
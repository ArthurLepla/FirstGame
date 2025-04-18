# DebugClick.gd
extends Node2D

@onready var ground_map: TileMap = get_node("/root/NightClearing/Environment/TileMap_Ground") # Corrected path

func _input(event):
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed:
		# Position de la souris → coords locales du TileMap
		var local_pos := ground_map.to_local(get_viewport().get_mouse_position())
		# Coordonnées de case (entiers)
		var cell := ground_map.local_to_map(local_pos)
		print("Tu as cliqué sur la case :", cell)

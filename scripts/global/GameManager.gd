# scripts/global/GameManager.gd
extends Node

enum Season { SPRING, SUMMER, FALL, WINTER }
enum Weather { CLEAR, RAIN, STORM }

# Variables principales
var current_time: float = 6.0 # 6h du matin
var current_season: Season = Season.SPRING
var current_weather: Weather = Weather.CLEAR
var day: int = 1

# Configuration
const DAY_LENGTH := 24.0 # durée d'une journée complète en heures

func _process(delta):
	current_time += delta * 0.5 # accélère le temps
	if current_time >= DAY_LENGTH:
		current_time = 0.0
		day += 1
		randomize_weather()

func get_formatted_time() -> String:
	var hours = int(current_time)
	var minutes = int((current_time - hours) * 60)
	return "%02d:%02d" % [hours, minutes]

func get_season_name() -> String:
	return ["Spring", "Summer", "Fall", "Winter"][current_season]

func get_weather_name() -> String:
	return ["Clear", "Rain", "Storm"][current_weather]

func randomize_weather():
	var roll = randi() % 100
	if roll < 70:
		current_weather = Weather.CLEAR
	elif roll < 90:
		current_weather = Weather.RAIN
	else:
		current_weather = Weather.STORM

func get_time_normalized() -> float:
	# Retourne le temps actuel normalisé entre 0.0 et 1.0
	return current_time / DAY_LENGTH
# UI_GameInfo.gd
extends CanvasLayer

@onready var time_label = $Bottom-left/Time
@onready var season_label = $Bottom-left/Season
@onready var weather_label = $Bottom-left/Weather

func _process(_delta):
	time_label.text = "Time: " + GameManager.get_formatted_time()
	season_label.text = "Season: " + GameManager.get_season_name()
	weather_label.text = "Weather: " + GameManager.get_weather_name()

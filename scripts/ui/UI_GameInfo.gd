# UI_GameInfo.gd
extends CanvasLayer

@onready var time_label = $BottomLeft/Time
@onready var season_label = $BottomLeft/Season
@onready var weather_label = $BottomLeft/Weather

func _process(_delta):
	time_label.text = "Time: " + GameManager.get_formatted_time()
	season_label.text = "Season: " + GameManager.get_season_name()
	weather_label.text = "Weather: " + GameManager.get_weather_name()

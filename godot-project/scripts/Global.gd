extends Node

# Game State
var current_level: int = 0
var score: int = 0
var high_score: int = 0
var player_name: String = "Player"
var last_player_name: String = ""
var scores: Array = []

# Level Configuration
const LEVELS = [
	{
		"name": "Gentle Breeze",
		"wind_min": 50.0,
		"wind_max": 100.0,
		"wind_change_interval": 3.0,
		"score_bonus": 100
	},
	{
		"name": "Strong Gust",
		"wind_min": 100.0,
		"wind_max": 200.0,
		"wind_change_interval": 2.5,
		"score_bonus": 200
	},
	{
		"name": "Tornado Warning",
		"wind_min": 150.0,
		"wind_max": 300.0,
		"wind_change_interval": 2.0,
		"score_bonus": 300
	}
]

const SAVE_PATH = "user://wind_jump_save.json"

func _ready():
	load_game_data()

func add_score(points: int):
	score += points

func reset_score():
	score = 0

func reset_game():
	current_level = 0
	score = 0

func get_current_level_config() -> Dictionary:
	if current_level < LEVELS.size():
		return LEVELS[current_level]
	return LEVELS[0]

func next_level() -> bool:
	current_level += 1
	return current_level < LEVELS.size()

func is_final_level() -> bool:
	return current_level >= LEVELS.size() - 1

func save_score():
	if score > high_score:
		high_score = score
	
	last_player_name = player_name
	
	# Add to scores array
	scores.append({
		"player_name": player_name,
		"score": score,
		"timestamp": Time.get_datetime_string_from_system()
	})
	
	# Sort and keep top 10
	scores.sort_custom(func(a, b): return a["score"] > b["score"])
	if scores.size() > 10:
		scores.resize(10)
	
	save_game_data()

func save_game_data():
	var data = {
		"high_score": high_score,
		"last_player_name": last_player_name,
		"scores": scores
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()

func load_game_data():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var json = JSON.new()
			var parse_result = json.parse(file.get_as_text())
			file.close()
			
			if parse_result == OK:
				var data = json.get_data()
				high_score = data.get("high_score", 0)
				last_player_name = data.get("last_player_name", "")
				scores = data.get("scores", [])
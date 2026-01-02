extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var wind_timer: Timer = $WindTimer
@onready var hud: CanvasLayer = $HUD
@onready var level_label: Label = $HUD/TopBar/LevelLabel
@onready var score_label: Label = $HUD/TopBar/ScoreLabel
@onready var high_score_label: Label = $HUD/TopBar/HighScoreLabel
@onready var wind_label: Label = $HUD/WindIndicator/WindLabel
@onready var wind_arrow: Label = $HUD/WindIndicator/WindArrow
@onready var platforms_container: Node2D = $Platforms
@onready var death_zone: Area2D = $DeathZone

var wind_force: float = 0.0
var wind_direction: int = 1
var target_wind_force: float = 0.0
var level_config: Dictionary

func _ready():
	# Get level configuration
	level_config = Global.get_current_level_config()
	
	# Connect signals
	player.player_died.connect(_on_player_died)
	player.player_jumped.connect(_on_player_jumped)
	death_zone.body_entered.connect(_on_death_zone_entered)
	wind_timer.timeout.connect(_on_wind_timer_timeout)
	
	# Setup level
	_setup_level()
	
	# Start wind timer
	wind_timer.wait_time = level_config["wind_change_interval"]
	wind_timer.start()
	
	# Initial wind
	_change_wind()
	
	# Update HUD
	_update_hud()

func _process(delta: float):
	# Smooth wind transition
	wind_force = lerp(wind_force, target_wind_force, delta * 2.0)
	
	# Apply wind to player
	player.set_wind(wind_force, wind_direction)
	
	# Update wind display
	_update_wind_display()

func _setup_level():
	# Update level label
	level_label.text = "Level: %d" % (Global.current_level + 1)
	
	# Initialize high score display
	high_score_label.text = "Best: %d" % Global.high_score

func _change_wind():
	# Random direction
	wind_direction = 1 if randf() > 0.5 else -1
	
	# Random force within level range
	target_wind_force = randf_range(level_config["wind_min"], level_config["wind_max"])

func _update_wind_display():
	wind_arrow.text = "→" if wind_direction > 0 else "←"
	
	var strength_range = level_config["wind_max"] - level_config["wind_min"]
	var strength_percent = (wind_force - level_config["wind_min"]) / strength_range
	
	if strength_percent < 0.33:
		wind_label.text = "Light"
	elif strength_percent < 0.66:
		wind_label.text = "Medium"
	else:
		wind_label.text = "Strong"

func _update_hud():
	score_label.text = "Score: %d" % Global.score
	high_score_label.text = "Best: %d" % Global.high_score

func _on_wind_timer_timeout():
	_change_wind()

func _on_player_jumped():
	Global.add_score(5)
	_update_hud()

func _on_player_died():
	_game_over()

func _on_death_zone_entered(body: Node2D):
	if body == player:
		_game_over()

func _on_finish_reached():
	wind_timer.stop()
	Global.add_score(level_config["score_bonus"])
	
	if Global.is_final_level():
		# Game complete
		Global.save_score()
		get_tree().change_scene_to_file("res://scenes/GameCompleteScreen.tscn")
	else:
		# Level complete
		get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn")

func _game_over():
	wind_timer.stop()
	Global.save_score()
	get_tree().change_scene_to_file("res://scenes/DefeatScreen.tscn")
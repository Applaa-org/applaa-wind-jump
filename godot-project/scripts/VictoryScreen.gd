extends Control

@onready var score_label: Label = $VBoxContainer/ScoreLabel
@onready var level_label: Label = $VBoxContainer/LevelLabel
@onready var new_high_score_label: Label = $VBoxContainer/NewHighScoreLabel
@onready var next_level_button: Button = $VBoxContainer/ButtonContainer/NextLevelButton
@onready var menu_button: Button = $VBoxContainer/ButtonContainer/MenuButton

func _ready():
	# Connect buttons
	next_level_button.pressed.connect(_on_next_level_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	
	# Display score
	score_label.text = "Score: %d" % Global.score
	level_label.text = "Level %d Cleared!" % (Global.current_level + 1)
	
	# Check for new high score
	if Global.score > Global.high_score:
		new_high_score_label.visible = true
	else:
		new_high_score_label.visible = false

func _on_next_level_pressed():
	Global.next_level()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_menu_pressed():
	Global.reset_game()
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")
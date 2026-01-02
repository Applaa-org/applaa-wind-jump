extends Control

@onready var high_score_label: Label = $VBoxContainer/StatsPanel/VBoxContainer/HighScoreLabel
@onready var last_player_label: Label = $VBoxContainer/StatsPanel/VBoxContainer/LastPlayerLabel
@onready var player_name_input: LineEdit = $VBoxContainer/NameContainer/PlayerNameInput
@onready var start_button: Button = $VBoxContainer/ButtonContainer/StartButton
@onready var close_button: Button = $VBoxContainer/ButtonContainer/CloseButton
@onready var leaderboard_container: VBoxContainer = $VBoxContainer/LeaderboardPanel/VBoxContainer/LeaderboardEntries

func _ready():
	# Connect buttons
	start_button.pressed.connect(_on_start_pressed)
	close_button.pressed.connect(_on_close_pressed)
	player_name_input.text_submitted.connect(_on_name_submitted)
	
	# Initialize display to 0
	high_score_label.text = "High Score: 0"
	high_score_label.visible = true
	
	# Load and display saved data
	_update_stats_display()
	_update_leaderboard()
	
	# Pre-fill player name
	if Global.last_player_name != "":
		player_name_input.text = Global.last_player_name

func _update_stats_display():
	high_score_label.text = "High Score: %d" % Global.high_score
	
	if Global.last_player_name != "":
		last_player_label.text = "Last Player: %s" % Global.last_player_name
	else:
		last_player_label.text = "Last Player: -"

func _update_leaderboard():
	# Clear existing entries
	for child in leaderboard_container.get_children():
		child.queue_free()
	
	if Global.scores.size() == 0:
		var empty_label = Label.new()
		empty_label.text = "No scores yet"
		empty_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
		leaderboard_container.add_child(empty_label)
		return
	
	# Show top 5 scores
	for i in range(min(5, Global.scores.size())):
		var entry = Global.scores[i]
		var entry_container = HBoxContainer.new()
		entry_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var name_label = Label.new()
		name_label.text = "%d. %s" % [i + 1, entry["player_name"]]
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
		
		var score_label = Label.new()
		score_label.text = str(entry["score"])
		score_label.add_theme_color_override("font_color", Color(1.0, 0.84, 0.0))
		
		entry_container.add_child(name_label)
		entry_container.add_child(score_label)
		leaderboard_container.add_child(entry_container)

func _on_start_pressed():
	var name = player_name_input.text.strip_edges()
	if name == "":
		name = "Player"
	Global.player_name = name
	Global.reset_game()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_close_pressed():
	get_tree().quit()

func _on_name_submitted(_text: String):
	_on_start_pressed()
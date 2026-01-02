extends Control

@onready var final_score_label: Label = $VBoxContainer/FinalScoreLabel
@onready var new_high_score_label: Label = $VBoxContainer/NewHighScoreLabel
@onready var play_again_button: Button = $VBoxContainer/ButtonContainer/PlayAgainButton
@onready var menu_button: Button = $VBoxContainer/ButtonContainer/MenuButton

func _ready():
	# Connect buttons
	play_again_button.pressed.connect(_on_play_again_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	
	# Display final score
	final_score_label.text = "Final Score: %d" % Global.score
	
	# Check for new high score
	if Global.score >= Global.high_score:
		new_high_score_label.visible = true
	else:
		new_high_score_label.visible = false

func _on_play_again_pressed():
	Global.reset_game()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_menu_pressed():
	Global.reset_game()
	get_tree().change_scene_to_file("res://scenes/StartScreen.tscn")
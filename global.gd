extends Node

var can_move = true
var text_open = false

var cromch_collected = 0
var cromch_in_level_collected = 0
#var total_cromch = 0
var global_cromch = 9

var melkoge_tip = 0
var melkoge_total_tip = 0
var melkoges = 4

var score = 0
var total_score = 0

#var hundoperc_interacted_lvl = 0.0
#var hundoperc_interacted = 0.0
var hundoperc_interactable = 13.0

var debug = false
var mute_music = false
var mute_sfx = false

var next_level = 0
var levels = ["res://scenes/level-1.tscn","res://scenes/level-2.tscn","res://scenes/level-3.tscn"]

var end_screen = 1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func end_game():
	#hundoperc_interacted += hundoperc_interacted_lvl
	total_score += score
	#cromch_collected += cromch_in_level_collected
	if end_screen == 2:
		get_tree().change_scene("res://scenes/end_game/end_level_2.tscn")
		return
	get_tree().change_scene("res://scenes/end_game/end_level_1.tscn")
	match end_screen:
		1: get_tree().change_scene("res://scenes/end_game/end_level_1.tscn") # Default Ending
		2: get_tree().change_scene("res://scenes/end_game/end_level_2.tscn") # True Bad Ending
		3: get_tree().change_scene("res://scenes/end_game/end_level_3.tscn") # Don't save Cheems
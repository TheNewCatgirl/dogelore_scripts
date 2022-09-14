extends Node2D

onready var global = get_node("/root/Global")

# Called when the node enters the scene tree for the first time.
func _ready():
	global.total_score += global.score
	global.cromch_in_level_collected = 0
	var percentage = 0
	if global.cromch_collected + global.melkoge_total_tip != 0 and global.hundoperc_interactable != 0:
		percentage = ceil((float(global.cromch_collected + global.melkoge_total_tip) / global.hundoperc_interactable) * 100)
	var score_perc_msg = "[center]Score: " + str(global.total_score) + "\n" + str(percentage) + "%"
	#print(global.cromch_collected)
	#print(str(global.hundoperc_interacted) + " / " + str(global.hundoperc_interactable) + " = " + str(percentage))
	var cromch_melk_msg =  "[center]CROMCH! bars collected: " + str(global.cromch_collected) + "/" + str(global.global_cromch) + "\nMelkoges tipped: " + str(global.melkoge_total_tip) + "/" + str(global.melkoges)
	$score_perc.set_bbcode(score_perc_msg)
	$cromch_melk.set_bbcode(cromch_melk_msg)

	
	#global.hundoperc_interacted = 0
	global.hundoperc_interactable = 0

	global.can_move = true
	global.cromch_collected = 0
	global.total_score = 0
	global.next_level = 0
	global.score = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_replay_pressed():
	print("pressed")
	get_tree().change_scene("res://scenes/level-1.tscn")

func _on_title_pressed():
	get_tree().change_scene("res://scenes/Title.tscn")

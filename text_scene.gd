extends Polygon2D

onready var global = get_node("/root/Global")
onready var player = get_node("/root/level/player")
onready var choicebox = $choice_box
onready var parent = get_tree().get_nodes_in_group("current_talker")[0]

export var dialogPath = ""
export(float) var textSpeed = 0.05

export var shop_dict_path = ""

var dialog
var item_list

var effect = "none"

var phraseNum = 0
var finished = false

var selected_ans = 1

var temp_lock = true

var item_num

func _ready():
	player.level_timer.set_paused(true)
	global.text_open = true
	$text_speed.wait_time = textSpeed
	dialog = getDialog()
	assert(dialog, "Dialog not found")
	nextPhrase()

func _process(_delta):
	#Load next phrase
	if Input.is_action_just_pressed("interact") and dialog[phraseNum-1]["Type"] != "Question":
		if finished:
			phraseNum = dialog[phraseNum-1]["Next"]
			nextPhrase()
			return
	
	#Player can skip text
	if Input.is_action_just_pressed("interact") and $text.visible_characters != len($text.text):
		$text.visible_characters = len($text.text)

	elif $text.visible_characters == len($text.text):
		#What happens if it's a question?
		if dialog[phraseNum-1]["Type"] == "Question":
			if Input.is_action_just_pressed("ui_up") :
				selected_ans -= 1
				if selected_ans < 1:
					selected_ans = dialog[phraseNum-1]["Answers"]
				for i in range(4) :
					if selected_ans == i + 1:
						var answer_selection = "choice_box/arrow" + str(selected_ans)
						var answer_arrow = get_node(answer_selection)
						answer_arrow.show()
					else :
						var answer_selection = "choice_box/arrow" + str(i+1)
						var answer_arrow = get_node(answer_selection)
						answer_arrow.hide()
			elif Input.is_action_just_pressed("ui_down")  :
				selected_ans += 1
				if selected_ans > dialog[phraseNum-1]["Answers"] :
					selected_ans = 1
					
				for i in range(4) :
					if selected_ans == i + 1:
						var answer_selection = "choice_box/arrow" + str(selected_ans)
						var answer_arrow = get_node(answer_selection)
						answer_arrow.show()
					elif selected_ans != i+1:
						var answer_selection = "choice_box/arrow" + str(i+1)
						var answer_arrow = get_node(answer_selection)
						answer_arrow.hide()
			
			if Input.is_action_just_pressed("interact")  :
				if finished:
					var ans_dialog = "Ans" + str(selected_ans) 
					var check = ans_dialog + "Check"
					if dialog[phraseNum-1][check] != "None" :
						match dialog[phraseNum-1][check]:
							"Item Check" : 
								print("what")
					else:
						phraseNum = dialog[phraseNum-1][ans_dialog]
						nextPhrase()
		#What if it's an answer?
		if  dialog[phraseNum-1]["Type"] == "Answer" :
			if finished :
				if dialog[phraseNum-1]["Effect"] != "None":
					effect = dialog[phraseNum-1]["Effect"]
	if Input.is_action_just_pressed("text debug"):
		print("Phrase Num: " + str(phraseNum) + " | Type: " + dialog[phraseNum]["Type"])
		print("Phrase Num - 1: " + str(phraseNum-1) + " | Type: " + dialog[phraseNum-1]["Type"])
		print("------------------------")
#Load dialog json
func getDialog() -> Array:
	var f = File.new()
	assert(f.file_exists(dialogPath), "File path does not exist")

	f.open(dialogPath, File.READ)
	var json = f.get_as_text()
	
	var output = parse_json(json)

	if typeof(output) == TYPE_ARRAY :
		return output
	else:
		return[]

#Load items json
#func getItems() -> Array:
#	var f = File.new()
#	assert(f.file_exists(item_path), "File path does not exist")
#
#	f.open(item_path, File.READ)
#	var json = f.get_as_text()
#	
#	var output = parse_json(json)
#
#	if typeof(output) == TYPE_ARRAY :
#		return output
#	else:
#		return[]

func nextPhrase() -> void:
	if phraseNum >= len(dialog):
		global.text_open = false
		global.can_move = true;
		player.level_timer.set_paused(false);
		player.change_emotions(0)
		if effect != "none":
			match effect:
				"jim_charge":
					parent.charge()
				"Endgame":
					global.end_game()
		queue_free()
		return

	finished = false

	$Name.bbcode_text = dialog[phraseNum]["Name"]
	$text.bbcode_text = dialog[phraseNum]["Text"]

	if dialog[phraseNum]["Source"] == "Player":
		player.change_emotions(dialog[phraseNum]["Face"])
	elif dialog[phraseNum]["Source"] == "Talker":
		parent.change_emotions(dialog[phraseNum]["Face"])

	if dialog[phraseNum]["Type"] == "Question":
		choicebox.show()
		for i in dialog[phraseNum]["Answers"] :
			var answer_select = "choice_box/answer" + str(i+1)
			var answer_block = get_node(answer_select)
			var answer_txt_in_dialog = "Ans" + str(i+1) + "Text"
			answer_block.set_text(dialog[phraseNum][answer_txt_in_dialog])
			answer_block.show()
			
	else:
		for i in range(4):
			var answer_select = "choice_box/answer" + str(i+1)
			var answer_block = get_node(answer_select)
			answer_block.hide()
		choicebox.hide()

	$text.visible_characters = 0

	while $text.visible_characters < len($text.text):
		$text.visible_characters += 1

		$text_speed.start()
		yield($text_speed, "timeout")

	finished = true
	phraseNum += 1
	return

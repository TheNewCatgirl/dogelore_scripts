extends Sprite

onready var global = get_node('/root/Global')

var change_input = false
var input = ""

export var screen = "Title"

func _ready():
	print(global.debug)
	if global.mute_music:
		if $music != null:
			print("hi" + str(global.mute_music))
			#$music.set_autoplay(false) 
			#$music.stop()
			$music.queue_free()
		if $music_input != null:
			$music_input.set_pressed_no_signal(true)
	if global.mute_sfx and $sfx_input != null:
		$sfx_input.set_pressed_no_signal(true)
	
	pass # Replace with function body.

#Navigation

func _on_play_pressed():
	get_tree().change_scene("res://scenes/level-1.tscn")

func _on_credits_pressed():
	get_tree().change_scene("res://scenes/credits.tscn")

func _on_options_pressed():
	get_tree().change_scene("res://scenes/options.tscn")

func _on_credits_return_pressed():
	get_tree().change_scene("res://scenes/Title.tscn")

func _on_options_return_pressed():
	if !change_input:
		get_tree().change_scene("res://scenes/Title.tscn")

#The following functions are all from Options.

#func _process():
#	pass
func _on_debug_pressed():
	global.debug = !global.debug
	print(global.debug)

func _on_music_pressed():
	global.mute_music = !global.mute_music
	print(global.mute_music)

func _on_sfx_pressed():
	global.mute_sfx = !global.mute_sfx
	print(global.mute_sfx)

func _on_jump_pressed():
	if !change_input:
		$Popup.popup()
		$Popup.set_title("Change Jump to")
		$Popup.popup_centered_clamped()
		change_input = true
		input = "jump"

func _on_left_pressed():
	if !change_input:
		$Popup.popup()
		$Popup.set_title("Change Left to")
		$Popup.popup_centered_clamped()
		change_input = true
		input = "left"

func _on_right_pressed():
	if !change_input:
		$Popup.popup()
		$Popup.set_title("Change Right to")
		$Popup.popup_centered_clamped()
		change_input = true
		input = "right"

func _on_down_pressed():
	if !change_input:
		$Popup.popup()
		$Popup.set_title("Change Down to")
		$Popup.popup_centered_clamped()
		change_input = true
		input = "down"

func _on_interact_pressed():
	if !change_input:
		$Popup.popup()
		$Popup.set_title("Change Interact to")
		$Popup.popup_centered_clamped()
		change_input = true
		input = "interact"
	
func _on_text_speed_pressed():
	match global.text_speed:
		0.1 :
			global.text_speed = 0.05
			$text_speed.set_text("Normal")
		0.05 :
			global.text_speed = 0.01
			$text_speed.set_text("Fast")
		0.0 :
			global.text_speed = 0.1
			$text_speed.set_text("Slow")
func _on_Popup_confirmed():
	change_input = false

func _input(event):
	if change_input:
		if event is InputEventKey:
			print(event.as_text())
			match input:
				"jump": 
					InputMap.action_erase_events("ui_up")
					InputMap.action_add_event("ui_up", event)
					$jump.set_text(event.as_text())
				"left": 
					InputMap.action_erase_events("ui_left")
					InputMap.action_add_event("ui_left", event)
					$left.set_text(event.as_text())
				"right":
					
					InputMap.action_erase_events("ui_right")
					InputMap.action_add_event("ui_right", event)
					$right.set_text(event.as_text())
				"down":
					InputMap.action_erase_events("ui_down")
					InputMap.action_add_event("ui_down", event)
					$down.set_text(event.as_text())
				"interact":
					InputMap.action_erase_events("interact")
					InputMap.action_add_event("interact", event)
					$interact.set_text(event.as_text())
			var popup_msg = "                   				 " + event.as_text()
			$Popup.set_text(popup_msg)

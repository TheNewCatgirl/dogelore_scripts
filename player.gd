extends KinematicBody2D

onready var global = get_node("/root/Global")

var speed = 10;
var JUMP_SPEED = 275;
var max_speed = 150
var deceleration = 20
var GRAVITY = 10
var velocity = Vector2()

var max_cam_displace = 200
var current_cam_displace = 0

var button_pressed = ''

var jump_able = true
var jumps = 1

var dead = false
var cause_of_death = ""
var level_end = false

var frames_per_second = 0

onready var level_timer = $level_timer
var timer_score = 0
var end_begin = false
var finalise = false

onready var cromch_in_level = get_tree().get_nodes_in_group("cromch").size()
var paused = false

#Load all SFX
onready var jump_sfx = load("res://Art/SFX & Music/SFX/Jump 1.wav")
onready var fall_sfx = load("res://Art/SFX & Music/SFX/Wilhelm 4.wav")
onready var gen_hurt_sfx = load("res://Art/SFX & Music/SFX/roblox-oof.wav")
onready var bull_gore_sfx = load("res://Art/SFX & Music/SFX/bull_gore.wav")
onready var water_sfx = load("res://Art/SFX & Music/SFX/water_drop.wav")

var health = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	global.can_move = true
	if global.next_level == 2:
		var factory_music = load("res://Art/SFX & Music/music/Factory.mp3")
		$music.set_stream(factory_music)
		$music.play()
		$Camera2D/ParallaxBackground/ParallaxLayer/green_field.hide()
	if global.debug:
		$Camera2D/CanvasLayer/speed_counter.show()
		$Camera2D/CanvasLayer/fps_counter.show()
		$Camera2D/CanvasLayer/button_pressed.show()
	if global.mute_music:
		$music.set_autoplay(false)
		$music.stop()
		$music.set_stream_paused(true)
	pass # Replace with function body.

var stop_gap = false
var win_playing = false
func _physics_process(_delta):
	get_input();
	if is_on_floor():
		jumps = 1
	velocity = move_and_slide(velocity, Vector2.UP);
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("enemy") and !collision.collider.killed:
			if collision.collider.name == "melkoge-bull":
				cause_of_death = "bull"
			hurt()
	
	if !level_end:
		var score_msg = "Score: " + str(global.total_score + global.score) + "\nTime: " + str(ceil($level_timer.get_time_left()))
		$Camera2D/CanvasLayer/ScoreTime.set_text(score_msg)
	if level_end:
		if !win_playing:
			var win_jingle = load("res://Art/SFX & Music/SFX/Level Complete.wav")
			$music.set_stream(win_jingle)
			if !global.mute_music:
				$music.play()
			win_playing = true
		if timer_score > 0 and !stop_gap:
			velocity.x += speed
			timer_score -= 1
			global.score += 1
			#print(int(timer_score))
			var score_msg = "Score: " + str(global.total_score + global.score) + "\nTime: " + str(int(timer_score))
			$Camera2D/CanvasLayer/ScoreTime.set_text(score_msg)
			if timer_score == 1:
				finalise = true
				if global.mute_music:
					$level_timer.set_wait_time(1)
					$level_timer.start()
			stop_gap = true
		elif stop_gap:
			stop_gap = false
	
	if global.debug:
		var speed_msg = "Speed: " + str(velocity.x)
		$Camera2D/CanvasLayer/fps_counter.set_text(str(Engine.get_frames_per_second()))
		$Camera2D/CanvasLayer/speed_counter.set_text(speed_msg)
		$Camera2D/CanvasLayer/button_pressed.set_text(button_pressed)

	if health <= 0 and !dead:
		death()

func get_input():

	if global.can_move == true:
		if Input.is_action_pressed("ui_right"):
			if velocity.x <= max_speed:
				velocity.x += speed;
				$player_sprite.set_flip_h(false)
				button_pressed = 'a'
		elif Input.is_action_pressed("ui_left"):
			if velocity.x >= -max_speed:
				velocity.x -= speed;
				$player_sprite.set_flip_h(true)
				button_pressed = 'd'
		else:
			if velocity.x != 0:
				if $player_sprite.flip_h:
					velocity.x += deceleration
				elif !$player_sprite.flip_h:
					velocity.x -= deceleration
				
				match $player_sprite.flip_h:
					true:
						if velocity.x > 0:
							velocity.x = 0
					false:
						if velocity.x < 0:
							velocity.x = 0
		if Input.is_action_just_pressed("ui_up") and (is_on_floor() or jumps > 0):
			if !global.mute_sfx:
				$sound_effects.set_stream(jump_sfx)
				$sound_effects.play()
			velocity.y = max(0, velocity.y)
			velocity.y -= JUMP_SPEED;
			if jumps == 1:
				jumps = 0
				velocity.y -= GRAVITY;
			button_pressed = 'w'
		
		if Input.is_action_pressed("ui_down"):
			if current_cam_displace < max_cam_displace:
				current_cam_displace += speed
				$Camera2D.transform.origin.y += speed
		else:
			if current_cam_displace != 0:
				$Camera2D.transform.origin.y -= speed
				current_cam_displace -= speed
		
		if Input.is_action_just_pressed("interact"):
			button_pressed = 'j'
	
	if Input.is_action_just_pressed("pause"):
		paused = !paused
		if paused:
			global.can_move = false 
			$Camera2D/CanvasLayer/paused.show()
			$level_timer.set_paused(true)
		if !paused:
			global.can_move = true
			$Camera2D/CanvasLayer/paused.hide()
			$level_timer.set_paused(false)
	
	velocity.y += GRAVITY

	if !global.can_move:
		if cause_of_death != "fall":
			velocity.y = 0
		if !level_end:
			velocity.x = 0

func change_emotions(emotion):
	$player_sprite.frame = emotion
	#0 - Normal
	#1 - Angry
	#2 - Confused
	#3 - Hurt

func _on_death_timer_timeout():
	reset()

func hurt():
	health -= 1

func _on_level_end_body_entered(body):
	if body.name == "player" and !level_end:
		level_end = true
		
		timer_score = int(ceil($level_timer.get_time_left()))
		$level_timer.stop()
		
		global.can_move = false
		$Camera2D.set_limit(2, get_position().x + 377)
		$Camera2D.set_limit(3, get_position().y + 135)
		$Camera2D.set_limit(1, get_position().y - 164)
		#print($player_sprite.get_position().x + 200)

		var score_msg = "Score: " + str(global.score) + "\nTime: " + str(119)
		$Camera2D/CanvasLayer/ScoreTime.set_text(score_msg)

func show_cromch():
	var cromch_shown_name = "Camera2D/CanvasLayer/Cromch" + str(global.cromch_in_level_collected)
	var cromch_shown = get_node(cromch_shown_name)
	cromch_shown.frame = 0
	pass

func _on_level_timer_timeout():
	if !level_end:
		death()
		return
	if finalise :
		finalize_level()

var win_tune = false

func death():
	match cause_of_death:
		"fall":
			$sound_effects.set_stream(fall_sfx)
		"general":
			$sound_effects.set_volume_db(-.018)
			$sound_effects.set_stream(gen_hurt_sfx)
		"bull":	
			$sound_effects.set_stream(bull_gore_sfx)
		"melk":
			$sound_effects.set_volume_db(-.018)
			$sound_effects.set_stream(water_sfx)
	if !global.mute_sfx:
		$sound_effects.play()
	else:
		$death_timer.start()
	change_emotions(3)
	global.can_move = false
	global.score = 0
	#global.cromch_collected -= global.cromch_in_level_collected
	#global.cromch_in_level_collected = 0
	#global.hundoperc_interacted -= global.hundoperc_interacted_lvl
	#global.hundoperc_interacted_lvl = 0 
	#global.melkoge_total_tip -= global.melkoge_tip
	#global.melkoge_tip = 0
	#reset()
	dead = true
	
func _on_sound_effects_finished():
	if dead:
		reset()
func _on_music_finished():
	if level_end:
		if finalise:
			$Camera2D/CanvasLayer/button_continue.show()
			$Camera2D/CanvasLayer/button_replay.show()
		win_tune = true


func collect_cromch():
	global.cromch_collected += 1
	global.cromch_in_level_collected += 1
	global.score += 100
	show_cromch()

func reset():
	#global.can_move = true
	global.cromch_collected -= global.cromch_in_level_collected
	global.cromch_in_level_collected = 0
	global.score = 0
	global.melkoge_total_tip -= global.melkoge_tip
	global.melkoge_tip = 0
	get_tree().reload_current_scene()

func finalize_level():
	print(global.mute_music)
	$Camera2D/CanvasLayer/button_continue.show()
	$Camera2D/CanvasLayer/button_replay.show()
	global.total_score += global.score
	global.score = 0
	pass

func _on_button_replay_pressed():
	#global.score = 0
	#global.cromch_collected -= global.cromch_collected
	#global.cromch_in_level_collected = 0
	#global.melkoge_tip = 0
	reset()
	global.can_move = true
	get_tree().change_scene(global.levels[global.next_level])

func _on_button_continue_pressed():
	global.total_score += global.score
	global.score = 0
	#global.cromch_collected += global.cromch_in_level_collected
	global.cromch_in_level_collected = 0
	#global.melkoge_total_tip += global.melkoge_tip
	global.melkoge_tip = 0
	global.next_level += 1
	global.can_move = true
	print("[center]Score: " + str(global.total_score) + "\n" + str(global.cromch_collected) + " Cromch")
	get_tree().change_scene(global.levels[global.next_level])

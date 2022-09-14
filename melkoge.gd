extends KinematicBody2D

onready var global = get_node("/root/Global")
export var move_speed = -100
var velocity = Vector2.ZERO
var direction = false
var gravity = 910

var killed = false

onready var bull_death_sfx = load("res://Art/SFX & Music/SFX/bull_death.wav")
var dying = false
var hunperc_int = 0

func _ready():
	#global.hundoperc_interactable += 1
	if !global.mute_sfx:
		var rand_timer_start = 0.5 + randf() * 8
		$sfx_timer.set_wait_time(rand_timer_start)
		$sfx_timer.start()
	pass

func _physics_process(_delta):
	if global.can_move and !killed:
		$Sprite.set_flip_h(direction)
		
		velocity.x = move_speed;
	else: velocity.x = 0;

	#if killed:
		#self_modulate(Color(.35,.35,.35))

	velocity = move_and_slide(velocity)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name != "player":
			if is_on_wall() and !killed and global.can_move:
				move_speed *= -1
				direction = !direction
		#if collision.collider.name == "player":
		#	collision.collider.hurt()

func _on_jumphere_body_entered(body):
	if body.name == "player":
		if !killed:
			dying = true
			global.score += 100
			$sfx_timer.stop()
			$sfx_player.stop()
			$sfx_player.set_stream(bull_death_sfx)
			$sfx_player.play()
			#global.hundoperc_interacted_lvl += 1.0
			global.melkoge_tip += 1
			global.melkoge_total_tip += 1
		killed = true
		$Sprite.set_flip_v(true)

func _on_sfx_timer_timeout():
	var rand_sfx = "res://Art/SFX & Music/SFX/bull_idle_" + str(randi() % 4) + ".wav"
	var final_sfx = load(rand_sfx)
	$sfx_player.set_stream(final_sfx)
	$sfx_player.play()

func _on_sfx_player_finished():
	if dying:
		$sfx_timer.queue_free()
		$sfx_player.queue_free()
		pass

	var rand_timer_start = 1 + randf() * 3
	$sfx_timer.set_wait_time(rand_timer_start)
	$sfx_timer.start()

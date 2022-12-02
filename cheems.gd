extends Area2D

#Modified from Talker framework

onready var global = get_node('/root/Global')
onready var player = get_node('/root/level/player')
onready var canvas = get_node('/root/level/CanvasLayer')

#Export variables shown in GD
export var dialog = "res://scripts/dialogs/dialog0.json"

var faces = "res://Art/DogeLore Assets/faces/cheems.png"

var in_body = false
var text_created = false;

#var section = 0;

func _ready():
	pass

func _process(_delta):
	pass
	if global.can_move:
	#Open talker's dialogue
		if Input.is_action_just_pressed("interact") and in_body and !global.text_open :
#			print("Total Cromch: " + str(global.cromch_collected))
#			print("Cromch In World: " + str(global.global_cromch))
			print("Cheems Score: " + str(global.total_score) + "\n" + str(global.cromch_collected) + " Cromch")
			if global.cromch_collected == global.global_cromch:
				dialog = "res://scripts/dialogs/final_variant_1.json"
				global.end_screen = 2
			else:
				global.end_screen = 1
			global.can_move = false;
			var b = load("res://resources/prefabs/text_scene.tscn").instance();
			b.dialogPath = dialog;
			canvas.add_child(b);
		if player.position.x > position.x :
			$Sprite.set_flip_h(true)
		elif $Sprite.flip_h:
			$Sprite.set_flip_h(false)

func _on_CheemsLayer_body_entered(body) :
	#Player is in the area, enable ability to do dialogue
	if body.name == 'player' :
		$interactsprite.show()
		$interactsprite.play("show")
		in_body = true
		add_to_group("current_talker")

func _on_CheemsLayer_body_exited(body):
	#Player left the area, no more ability to turn them off
	if body.name == 'player' :
		in_body = false
		remove_from_group("current_talker")
		$interactsprite.play("hide")
		$animtimer.start()

func change_emotions(emotion):
	$Sprite.frame = emotion
	#0 - Normal
	#1 - Sad
	#2 - Front face
	#3 - Universe

func _on_animtimer_timeout():
	$interactsprite.hide()

extends Area2D

onready var global = get_node('/root/Global')
onready var player = get_node('/root/level/player')
onready var canvas = get_node('/root/level/CanvasLayer')

#Export variables shown in GD
export var dialog = "res://scripts/dialogs/dialog0.json"
export var minor_obj = false #Minor objects (Small things with 1-2 dialogue lines)
export var minor_obj_num = 0
export var shop = false #Shops
export var shop_path = ""

var in_body = false
var text_created = false;

var section = 0;

func _ready():
	pass

func _process(_delta):
	pass
	if global.can_move:
	#Open talker's dialogue
		if Input.is_action_just_pressed("interact") and in_body and !global.text_open :
			global.can_move = false;
			var b = load("res://resources/prefabs/text_scene.tscn").instance();
			b.dialogPath = dialog;
			canvas.add_child(b);
		if player.position.x > position.x :
			$Sprite.set_flip_h(true)
		elif $Sprite.flip_h:
			$Sprite.set_flip_h(false)

func _on_talker_body_entered(body) :
	#Player is in the area, enable ability to do dialogue
	if body.name == 'player' :
		$interactsprite.show()
		$interactsprite.play("show")
		in_body = true
		add_to_group("current_talker")
		#if shop:
		#	global.is_shop = true;
		#	global.shop_path = shop_path;

func _on_talker_body_exited(body):
	#Player left the area, no more ability to turn them off
	if body.name == 'player' :
		in_body = false
		remove_from_group("current_talker")
		$interactsprite.play("hide")
		$animtimer.start()

func change_emotions(emotion):
	$Sprite.frame = emotion
	#0 - Normal
	#Caesar has no other emotions

func _on_animtimer_timeout():
	$interactsprite.hide()
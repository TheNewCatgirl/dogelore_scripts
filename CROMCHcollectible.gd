extends Area2D

onready var global = get_node('/root/Global')
onready var player = get_node('/root/level/player')

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var collected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#global.hundoperc_interactable += 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_collectable_body_entered(body):
	if body.name == "player" and !collected:
		body.collect_cromch()
		$AudioStreamPlayer.play()
		hide()
		collected = true      

func _on_AudioStreamPlayer_finished():
	queue_free()
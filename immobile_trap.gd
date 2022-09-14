extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var cause = "general"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_spikes_body_entered(body):
	if body.name == "player":
		body.health -= 1
		body.cause_of_death = cause
		print(body.health)
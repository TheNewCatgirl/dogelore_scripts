extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var hidden = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Hidden_Area_body_entered(body):
	if body.name == "player":
		if !hidden:
			hidden = true
			print("hello")
			hide()
			var reveal = AudioStreamPlayer.new()
			add_child(reveal)
			var stream = load("res://Art/SFX & Music/SFX/Random 1.wav")
			reveal.set_stream(stream)
			reveal.set_volume_db(-18)
			reveal.play()
			var t = Timer.new()
			t.set_wait_time(.5)
			t.set_one_shot(true)
			self.add_child(t)
			t.start()
			yield(t, "timeout")
			t.queue_free()
			reveal.queue_free()
			

extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var sound_played = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	
	#POP Ballon with sound
	if sound_played == false:
		if scale.x > 1.3:
			visible = false
			if get_node("AudioStreamPlayer").playing == false:
				get_node("AudioStreamPlayer").play()
				sound_played = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

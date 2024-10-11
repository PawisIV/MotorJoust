extends Control

onready var Label = $Label
onready var Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	Timer.start()
	
func time_left_to_live():
	var time_left = Timer.time_left
	var second = int(time_left)
	return [second]

func _process(delta):
	Label.text = "%02d"% time_left_to_live()

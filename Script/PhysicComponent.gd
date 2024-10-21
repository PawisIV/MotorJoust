extends KinematicBody2D

# Variables for movement
var acceleration = 0.0
var max_speed = 0.0
var friction = 0
var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO

# Signals to handle input from player script
signal force_up
signal force_down
signal force_left
signal force_right
signal no_input
signal inputvector
func _ready():
	# Connect the signals from the player script
	connect("force_up", self, "_on_up")
	connect("force_down", self, "_on_down")
	connect("force_left", self, "_on_left")
	connect("force_right", self, "_on_right")
	connect("no_input", self, "_on_no_input")
	connect("inputvector", self, "_on_override_input")
func _physics_process(_delta):
	# Apply acceleration and update velocity based on input
	if input_vector.length() > 0:
		velocity += input_vector.normalized() * acceleration * _delta

	# Clamp the velocity to max speed
	velocity = velocity.limit_length(max_speed)
	velocity = move_and_slide(velocity)

# Signal Functions
func _on_up(arg1):
	# Only modify the y-axis without resetting the x-axis
	input_vector.y = -arg1


func _on_down(arg1):
	# Only modify the y-axis without resetting the x-axis
	input_vector.y = arg1

func _on_left(arg1):
	# Only modify the x-axis without resetting the y-axis
	input_vector.x = -arg1


func _on_right(arg1):
	# Only modify the x-axis without resetting the y-axis
	input_vector.x = arg1

func _on_no_input():
	# Reset input vector to stop movement
	input_vector = Vector2.ZERO

func on_set_variable(arg1, arg2, arg3):
	acceleration = arg1
	max_speed = arg2
	friction = arg3
func _on_override_input(arg1):
	input_vector = arg1

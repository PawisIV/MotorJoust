extends KinematicBody2D

# Variables for movement
var acceleration = 200.0
var max_speed = 800.0
var friction = 0
var rotation_speed = 0.1
var velocity = Vector2.ZERO
var drift_factor = 0.2

# Signals to handle input from player script
signal go_up
signal go_down
signal go_left
signal go_right
signal no_input

# Flags to control the state
var is_go_up = false
var is_go_down = false
var is_go_left = false
var is_go_right = false

func _ready():
	# Connect the signals from the player script
	connect("go_up", self, "_on_throttle_pressed")
	connect("go_down", self, "_on_brake_pressed")
	connect("go_left", self, "_on_turn_left")
	connect("go_right", self, "_on_turn_right")
	connect("no_input", self, "_on_no_input")

func _physics_process(_delta):
	# Steering and throttle control based on flags
	var input_vector = Vector2(0 , 0)
	#Handling Singal#
	if is_go_up:
		input_vector.y -= 1
	elif is_go_down:
		input_vector.y += 1

	if is_go_left:
		input_vector.x -= 1
	elif is_go_right:
		input_vector.x += 1

	# Apply acceleration and friction
	if input_vector.length() > 0:
		velocity += input_vector.normalized() * acceleration * _delta

	# Clamp the velocity to max speed
	velocity = velocity.limit_length(max_speed)
	velocity = move_and_slide(velocity)

#Signal Funaction
func _on_throttle_pressed():
	is_go_up = true
	is_go_down= false
func _on_brake_pressed(): 
	is_go_down = true
	is_go_up = false

func _on_turn_left():
	is_go_left = true
	is_go_right= false

func _on_turn_right():
	is_go_right = true
	is_go_left = false

func _on_no_input():
	is_go_up = false
	is_go_down= false
	is_go_right = false
	is_go_left = false



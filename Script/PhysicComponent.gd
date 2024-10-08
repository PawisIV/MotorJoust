extends KinematicBody2D

# Variables for movement
var acceleration = 200.0
var max_speed = 800.0
var friction = 0
var rotation_speed = 0.1
var velocity = Vector2.ZERO
var drift_factor = 0.2

# Signals to handle input from player script
signal throttle_pressed
signal brake_pressed
signal turn_left
signal turn_right
signal no_input

# Flags to control the state
var is_throttling = false
var is_braking = false
var is_turning_left = false
var is_turning_right = false

func _ready():
	# Connect the signals from the player script
	connect("throttle_pressed", self, "_on_throttle_pressed")
	connect("brake_pressed", self, "_on_brake_pressed")
	connect("turn_left", self, "_on_turn_left")
	connect("turn_right", self, "_on_turn_right")
	connect("no_input", self, "_on_no_input")

func _physics_process(_delta):
	# Steering and throttle control based on flags
	var input_vector = Vector2.ZERO

	if is_throttling:
		input_vector.y -= 1
		print(velocity)
	elif is_braking:
		input_vector.y += 1

	if is_turning_left:
		rotation -= rotation_speed * _delta
	elif is_turning_right:
		rotation += rotation_speed * _delta

	# Apply acceleration and friction
	var direction = Vector2(cos(rotation), sin(rotation))
	if input_vector.y != 0:
		velocity += direction * input_vector.y * acceleration * _delta
	else:
		velocity = velocity.linear_interpolate(Vector2.ZERO, friction * _delta)

	# Clamp the velocity to max speed
	velocity = velocity.limit_length(max_speed)

	# Apply drift and movement
	var drift_vector = velocity.rotated(rotation).normalized()
	velocity = velocity.linear_interpolate(drift_vector * velocity.length(), drift_factor)

	# Move the player
	velocity = move_and_slide(velocity)

# Signal handlers
#func _on_throttle_pressed():

func _on_throttle_pressed():
	is_throttling = true
	is_braking = false
func _on_brake_pressed(): 
	is_braking = true
	is_throttling = false

func _on_turn_left():
	is_turning_left = true
	is_turning_right = false

func _on_turn_right():
	is_turning_right = true
	is_turning_left = false

func _on_no_input():
	is_turning_left = false
	is_turning_right = false
	is_throttling = false
	is_braking= false




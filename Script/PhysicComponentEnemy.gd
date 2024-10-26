extends KinematicBody2D

# Variables for movement
var acceleration = 0.0
var max_speed = 0.0
var friction = 0
var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO

signal no_input
func _ready():
	pass
	# Connect the signals from the player script

func _physics_process(_delta):
	# Apply acceleration and update velocity based on input
	if input_vector.length() > 0:
		velocity += input_vector.normalized() * acceleration * _delta

	# Clamp the velocity to max speed
	velocity = velocity.limit_length(max_speed)
	velocity = move_and_slide(velocity)

# Signal Functions
func _on_no_input():
	# Reset input vector to stop movement
	input_vector = Vector2.ZERO

func on_set_variable(arg1, arg2, arg3):
	acceleration = arg1
	max_speed = arg2
	friction = arg3
func _on_override_input(arg1):
	input_vector = arg1


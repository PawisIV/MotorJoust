extends KinematicBody2D

var speed = 200
var turn_speed = 5  # Speed of turning towards the player
var charge_speed = 400  # Speed when charging towards the player
var player: KinematicBody2D = null
var velocity = Vector2.ZERO
var charging = false
var charge_chance = 0.01  # 1% chance to charge each frame
var charge_duration = 1.5  # Time to stay charging
var charge_timer = 0.0

func _ready():
	player = get_node("/root/MainScene/PlayerNode/PhysicComponent")

func _physics_process(delta):
	if player:
		# Calculate direction to player
		var direction_to_player = (player.global_position - global_position).normalized()

		# Rotate smoothly towards the player
		if not charging:
			var target_angle = direction_to_player.angle()
			rotation = lerp_angle(rotation, target_angle, turn_speed * delta)

			# Randomly start charging (even from far away)
			if randf() < charge_chance:
				charging = true
				charge_timer = charge_duration  # Set the charge duration timer
		else:
			charge_timer -= delta  # Reduce the charge timer
			if charge_timer <= 0:
				charging = false  # Stop charging when time is up

		# If the enemy is charging, move forward at charge speed
		if charging:
			velocity = Vector2.RIGHT.rotated(rotation) * charge_speed
		else:
			# Normal movement toward the player
			velocity = Vector2.RIGHT.rotated(rotation) * speed

		# Move the enemy
		move_and_slide(velocity)

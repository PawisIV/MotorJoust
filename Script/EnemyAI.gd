extends KinematicBody2D

var speed = 200
var turn_speed = 5  # Speed of turning towards the player
var charge_speed = 400  # Speed when charging towards the player
var player: KinematicBody2D = null
var velocity = Vector2.ZERO
var charging = false
var approach_offset = 45  # Angle offset for smarter approach (in degrees)
var zigzag_pattern = false  # Enable zigzag pattern
var random_charge_threshold = 0.01  # Probability of charging each frame (adjust this value for randomness)

func _ready():
	player = get_node("/root/MainScene/PlayerNode/PhysicComponent")

func _physics_process(delta):
	if player:
		# Calculate direction to player
		var direction_to_player = (player.global_position - global_position).normalized()

		# Smarter approach: Apply an angle offset to the direction towards the player
		var angle_offset = deg2rad(approach_offset)
		if charging:
			angle_offset = 0  # No offset during charging (charge directly to player)
		elif zigzag_pattern:
			# Zigzag movement: Switch offset every frame to alternate approach angle
			approach_offset *= -1

		# Rotate the direction to the player by the offset (only if not charging)
		var direction_with_offset = direction_to_player.rotated(angle_offset)

		# Rotate smoothly towards the offset direction
		if not charging:
			var target_angle = direction_with_offset.angle()
			rotation = lerp_angle(rotation, target_angle, turn_speed * delta)

		# Randomly trigger charging behavior
		if randi() % 100 < random_charge_threshold * 100 and not charging:
			charging = true

		# Charging behavior: Move directly towards the player without offsets
		if charging:
			# Recalculate direction to player for accurate charge
			var direct_direction = (player.global_position - global_position).normalized()
			velocity = Vector2.RIGHT.rotated(rotation) * charge_speed
		else:
			# Normal movement with smarter angle toward the player
			velocity = Vector2.RIGHT.rotated(rotation) * speed

		# Move the enemy
		move_and_slide(velocity)

		# If the enemy is far from the player again, stop charging
		if global_position.distance_to(player.global_position) > 300 and charging:
			charging = false

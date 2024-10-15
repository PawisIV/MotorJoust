extends KinematicBody2D

var speed = 200
var turn_speed = 5  # Speed of turning towards the player
var separation_distance = 100  # Minimum distance between enemies
var separation_strength = 300  # Strength of separation force
var charge_speed = 400  # Speed when charging towards the player
var player: KinematicBody2D = null
var velocity = Vector2.ZERO
var charging = false

func _ready():
	player = get_node("/root/MainScene/PlayerNode/PhysicComponent")

func _physics_process(delta):
	if player:
		# Calculate direction to player
		var direction_to_player = (player.global_position - global_position).normalized()
		
		# Apply separation force from nearby enemies
		var separation_force = get_separation_force()

		# Combine movement direction towards player and separation force
		var final_direction = direction_to_player + separation_force.normalized()
		final_direction = final_direction.normalized()

		# Rotate smoothly towards the player
		if not charging:
			var target_angle = final_direction.angle()
			rotation = lerp_angle(rotation, target_angle, turn_speed * delta)
		
		# If the enemy is close to the player, start charging
		if global_position.distance_to(player.global_position) < 150 and not charging:
			charging = true
		
		# Keep moving forward even after colliding with the player (joust-like behavior)
		if charging:
			velocity = Vector2.RIGHT.rotated(rotation) * charge_speed
		else:
			# Normal movement toward the player
			velocity = Vector2.RIGHT.rotated(rotation) * speed
		
		# Move the enemy
		move_and_slide(velocity)

		# If the enemy is far from the player again, stop charging
		if global_position.distance_to(player.global_position) > 300 and charging:
			charging = false

func get_separation_force() -> Vector2:
	var separation_force = Vector2.ZERO

	# Get all enemies in the scene
	var enemies = get_parent().get_children()
	
	# Loop through enemies and apply separation force if they are too close
	for enemy in enemies:
		if enemy != self and enemy is KinematicBody2D:
			var distance_to_enemy = global_position.distance_to(enemy.global_position)
			
			# If the enemy is too close, apply a separation force
			if distance_to_enemy < separation_distance:
				var push_direction = (global_position - enemy.global_position).normalized()
				var push_strength = (separation_distance - distance_to_enemy) / separation_distance
				separation_force += push_direction * push_strength * separation_strength

	return separation_force

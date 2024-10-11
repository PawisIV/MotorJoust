extends KinematicBody2D

# Speed at which the enemy moves
var speed = 200
# Reference to the player's PhysicComponent
var player: KinematicBody2D = null
var velocity
var separation_distance = 100  # Minimum distance between enemies
var separation_strength = 300  # How strong the separation force is

func _ready():
	# Access the PhysicComponent of the player
	player = get_node("/root/MainScene/PlayerNode/PhysicComponent")

func _physics_process(delta):
	if player:
		# Calculate the direction towards the player
		var direction = (player.global_position - global_position).normalized()
		# Move the enemy towards the player
		move_and_slide(direction * speed)

